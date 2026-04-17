const dom = {
  form: document.getElementById('tracking-form'),
  rideId: document.getElementById('ride-id'),
  bearerToken: document.getElementById('bearer-token'),
  backendUrl: document.getElementById('backend-url'),
  realtimeUrl: document.getElementById('realtime-url'),
  disconnectBtn: document.getElementById('disconnect-btn'),
  clearLogBtn: document.getElementById('clear-log-btn'),
  connectionStatus: document.getElementById('connection-status'),
  connectionDetail: document.getElementById('connection-detail'),
  rideStatus: document.getElementById('ride-status'),
  trackingStatus: document.getElementById('tracking-status'),
  etaText: document.getElementById('eta-text'),
  distanceText: document.getElementById('distance-text'),
  driverName: document.getElementById('driver-name'),
  driverPhone: document.getElementById('driver-phone'),
  vehicleNumber: document.getElementById('vehicle-number'),
  vehicleType: document.getElementById('vehicle-type'),
  pickupAddress: document.getElementById('pickup-address'),
  destinationAddress: document.getElementById('destination-address'),
  lastPing: document.getElementById('last-ping'),
  roomName: document.getElementById('room-name'),
  mapWarning: document.getElementById('map-warning'),
  eventLog: document.getElementById('event-log'),
};

const state = {
  socket: null,
  map: null,
  pickupMarker: null,
  destinationMarker: null,
  driverMarker: null,
  routeLine: null,
  driverPath: [],
};

const DRIVER_ICON = L.divIcon({
  className: 'driver-pin',
  html: '<div style="width:18px;height:18px;border-radius:999px;background:#bf5a36;border:3px solid #fff;box-shadow:0 6px 16px rgba(0,0,0,.22)"></div>',
  iconSize: [18, 18],
  iconAnchor: [9, 9],
});

function initMap() {
  state.map = L.map('map', {
    zoomControl: true,
  }).setView([10.7769, 106.7009], 13);

  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; OpenStreetMap contributors',
  }).addTo(state.map);
}

function setConnection(status, detail, tone = 'default') {
  dom.connectionStatus.textContent = status;
  dom.connectionDetail.textContent = detail;

  const colors = {
    default: '#231d18',
    success: '#1f6f50',
    warning: '#b66a16',
    danger: '#a32929',
  };

  dom.connectionStatus.style.color = colors[tone] || colors.default;
}

function formatDateTime(value) {
  if (!value) {
    return '-';
  }

  const date = new Date(value);

  if (Number.isNaN(date.getTime())) {
    return value;
  }

  return new Intl.DateTimeFormat('vi-VN', {
    dateStyle: 'short',
    timeStyle: 'medium',
  }).format(date);
}

function appendLog(title, payload) {
  const item = document.createElement('li');
  const timestamp = payload?.occurred_at || payload?.tracked_at || new Date().toISOString();
  const message = payload?.message || payload?.warning || 'Đã nhận event';

  item.innerHTML = `
    <strong>${title}</strong>
    <div>${message}</div>
    <small>${formatDateTime(timestamp)}</small>
  `;

  dom.eventLog.prepend(item);
}

function updateInfo(snapshot) {
  const ride = snapshot.ride || {};
  const driver = snapshot.driver || {};
  const location = snapshot.location || {};
  const eta = snapshot.eta || {};

  dom.rideStatus.textContent = ride.status_label || '-';
  dom.trackingStatus.textContent = ride.tracking_status_label || '-';
  dom.etaText.textContent = eta.text || '-';
  dom.distanceText.textContent = eta.distance_to_pickup_meters != null
    ? `${eta.distance_to_pickup_meters} m tới điểm đón`
    : '-';
  dom.driverName.textContent = driver.name || '-';
  dom.driverPhone.textContent = driver.phone || '-';
  dom.vehicleNumber.textContent = driver.vehicle_number || '-';
  dom.vehicleType.textContent = driver.vehicle_type_label || '-';
  dom.pickupAddress.textContent = ride.pickup_address || '-';
  dom.destinationAddress.textContent = ride.destination_address || '-';
  dom.lastPing.textContent = formatDateTime(ride.tracking_last_ping_at || location.updated_at);
  dom.roomName.textContent = snapshot.realtime?.room || '-';

  if (snapshot.warning) {
    dom.mapWarning.textContent = snapshot.warning;
    dom.mapWarning.classList.remove('hidden');
  } else {
    dom.mapWarning.classList.add('hidden');
  }
}

function updateMap(snapshot) {
  const ride = snapshot.ride || {};
  const location = snapshot.location || {};

  if (ride.pickup_address && ride.destination_address && ride.id) {
    const pickupLatLng = [ride.pickup_lat, ride.pickup_lng].filter((value) => value != null);
    const destinationLatLng = [ride.destination_lat, ride.destination_lng].filter((value) => value != null);

    if (pickupLatLng.length === 2) {
      if (!state.pickupMarker) {
        state.pickupMarker = L.marker(pickupLatLng).addTo(state.map).bindPopup('Điểm đón');
      } else {
        state.pickupMarker.setLatLng(pickupLatLng);
      }
    }

    if (destinationLatLng.length === 2) {
      if (!state.destinationMarker) {
        state.destinationMarker = L.marker(destinationLatLng).addTo(state.map).bindPopup('Điểm đến');
      } else {
        state.destinationMarker.setLatLng(destinationLatLng);
      }
    }
  }

  if (typeof location.lat !== 'number' || typeof location.lng !== 'number') {
    return;
  }

  const latLng = [location.lat, location.lng];

  if (!state.driverMarker) {
    state.driverMarker = L.marker(latLng, { icon: DRIVER_ICON }).addTo(state.map).bindPopup('Tài xế');
  } else {
    state.driverMarker.setLatLng(latLng);
  }

  state.driverPath.push(latLng);

  if (state.routeLine) {
    state.routeLine.setLatLngs(state.driverPath);
  } else {
    state.routeLine = L.polyline(state.driverPath, {
      color: '#bf5a36',
      weight: 4,
      opacity: 0.75,
    }).addTo(state.map);
  }

  const bounds = L.latLngBounds(state.driverPath);

  if (state.pickupMarker) {
    bounds.extend(state.pickupMarker.getLatLng());
  }

  if (state.destinationMarker) {
    bounds.extend(state.destinationMarker.getLatLng());
  }

  state.map.fitBounds(bounds, { padding: [40, 40] });
}

function disconnectSocket() {
  if (state.socket) {
    state.socket.disconnect();
    state.socket = null;
  }

  setConnection('Disconnected', 'Đã ngắt kết nối realtime', 'warning');
}

async function fetchSnapshot({ rideId, backendUrl, bearerToken }) {
  const response = await fetch(`${backendUrl.replace(/\/$/, '')}/api/v1/ride/${rideId}/tracking`, {
    headers: {
      Accept: 'application/json',
      Authorization: bearerToken ? `Bearer ${bearerToken}` : '',
    },
  });

  const payload = await response.json();

  if (!response.ok || !payload.success) {
    throw new Error(payload.message || 'Không lấy được snapshot tracking.');
  }

  return payload.data;
}

function connectRealtime({ rideId, realtimeUrl }) {
  disconnectSocket();

  state.socket = io(realtimeUrl, {
    transports: ['websocket', 'polling'],
    auth: { rideId },
  });

  state.socket.on('connect', () => {
    setConnection('Connected', `Socket ${state.socket.id}`, 'success');
    state.socket.emit('ride:join', { rideId });
  });

  state.socket.on('disconnect', (reason) => {
    setConnection('Disconnected', reason, 'warning');
  });

  state.socket.on('connect_error', (error) => {
    setConnection('Error', error.message, 'danger');
    appendLog('Socket Error', { message: error.message, occurred_at: new Date().toISOString() });
  });

  state.socket.on('ride:tracking.state', (payload) => {
    updateInfo(payload);
    updateMap(payload);
    appendLog(payload.event || 'tracking.state', payload);
  });

  state.socket.on('ride:tracking.updated', (payload) => {
    updateInfo(payload);
    updateMap(payload);
    appendLog(payload.event || 'tracking.updated', payload);
  });
}

function resetPath() {
  state.driverPath = [];

  if (state.routeLine) {
    state.map.removeLayer(state.routeLine);
    state.routeLine = null;
  }
}

dom.form.addEventListener('submit', async (event) => {
  event.preventDefault();

  const rideId = dom.rideId.value.trim();
  const backendUrl = dom.backendUrl.value.trim();
  const realtimeUrl = dom.realtimeUrl.value.trim();
  const bearerToken = dom.bearerToken.value.trim();

  if (!rideId) {
    setConnection('Missing Ride ID', 'Bạn phải nhập rideId', 'danger');
    return;
  }

  try {
    setConnection('Loading', 'Đang lấy snapshot tracking...', 'warning');
    resetPath();

    const snapshot = await fetchSnapshot({
      rideId,
      backendUrl,
      bearerToken,
    });

    updateInfo(snapshot);
    updateMap(snapshot);
    appendLog(snapshot.event || 'tracking.snapshot', snapshot);

    connectRealtime({ rideId, realtimeUrl });
  } catch (error) {
    setConnection('Error', error.message, 'danger');
    appendLog('Snapshot Error', {
      message: error.message,
      occurred_at: new Date().toISOString(),
    });
  }
});

dom.disconnectBtn.addEventListener('click', () => {
  disconnectSocket();
});

dom.clearLogBtn.addEventListener('click', () => {
  dom.eventLog.innerHTML = '';
});

initMap();
setConnection('Idle', 'Chưa kết nối');
