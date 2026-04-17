/**
 * NHM Ride Cycle Demo Logic
 */

let socket = null;

const elements = {
    joinForm: document.getElementById('join-form'),
    rideId: document.getElementById('ride-id'),
    realtimeUrl: document.getElementById('realtime-url'),
    connectBtn: document.getElementById('connect-btn'),
    disconnectBtn: document.getElementById('disconnect-btn'),
    indicator: document.getElementById('conn-indicator'),
    statusText: document.getElementById('conn-text'),
    roomDisplay: document.getElementById('room-name'),
    logList: document.getElementById('log-list'),
    clearBtn: document.getElementById('clear-btn'),
    
    backendUrl: document.getElementById('backend-url'),
    driverToken: document.getElementById('driver-token'),
    acceptBtn: document.getElementById('accept-btn'),
    rejectBtn: document.getElementById('reject-btn'),
    cancelBtn: document.getElementById('cancel-btn'),
};

// ── Realtime Logic ─────────────────────────────────────────────────────────

function addLog(type, title, data = null) {
    if (elements.logList.querySelector('.subtle')) {
        elements.logList.innerHTML = '';
    }

    const li = document.createElement('li');
    li.className = 'log-item';
    
    let content = `
        <small>${new Date().toLocaleTimeString()}</small>
        <strong>[${type.toUpperCase()}] ${title}</strong>
    `;

    if (data) {
        content += `<pre>${JSON.stringify(data, null, 2)}</pre>`;
    }

    li.innerHTML = content;
    elements.logList.prepend(li);
}

function updateStatus(connected, text, room = 'Chưa vào') {
    elements.indicator.className = `connection-indicator ${connected ? 'online' : 'offline'}`;
    elements.statusText.innerText = text;
    elements.roomDisplay.innerText = room;
    elements.connectBtn.disabled = connected;
    elements.disconnectBtn.disabled = !connected;
}

function connect() {
    const url = elements.realtimeUrl.value;
    const rideId = elements.rideId.value;

    if (!rideId) {
        alert('Vui lòng nhập Ride ID');
        return;
    }

    if (socket) socket.disconnect();

    addLog('System', `Bắt đầu kết nối tới ${url}...`);

    socket = io(url, {
        transports: ['websocket'],
    });

    socket.on('connect', () => {
        addLog('System', 'Kết nối thành công!');
        updateStatus(true, 'Connected', 'Đang yêu cầu vào phòng...');
        
        // Gửi lệnh tham gia phòng chuyến xe
        socket.emit('ride:join', { rideId }, (response) => {
            if (response.ok) {
                addLog('System', `Đã tham gia phòng: ${response.room}`);
                elements.roomDisplay.innerText = response.room;
            } else {
                addLog('Error', 'Không thể tham gia phòng', response);
                elements.roomDisplay.innerText = 'Lỗi';
            }
        });
    });

    socket.on('disconnect', () => {
        addLog('System', 'Ngắt kết nối.');
        updateStatus(false, 'Disconnected', 'Chưa vào');
    });

    socket.on('connect_error', (error) => {
        addLog('Error', 'Lỗi kết nối Socket.io', error.message);
        updateStatus(false, 'Error', 'Lỗi');
    });

    // Lắng nghe các sự kiện về chuyến xe
    const events = ['ride.accepted', 'ride.rejected', 'ride.cancelled', 'ride:tracking.updated'];
    
    events.forEach(event => {
        socket.on(event, (data) => {
            addLog('Event', event, data);
        });
    });

    // Lắng nghe mọi sự kiện để debug
    socket.onAny((event, data) => {
        if (!events.includes(event)) {
            addLog('Debug', `Event: ${event}`, data);
        }
    });
}

// ── Backend API Logic ──────────────────────────────────────────────────────

async function callDriverApi(action) {
    const rideId = elements.rideId.value;
    const baseUrl = elements.backendUrl.value;
    const token = elements.driverToken.value;

    if (!rideId) {
        alert('Vui lòng nhập Ride ID');
        return;
    }

    let url = `${baseUrl}/api/v1/driver/ride/${rideId}/${action}`;
    
    // Đối với accept, cần truyền tọa độ mẫu
    let body = {};
    if (action === 'accept') {
        body = {
            current_lat: 10.776889,
            current_lng: 106.700806
        };
    } else if (action === 'cancel') {
        body = {
            reason_id: 1, // Khách không ra
            current_lat: 10.776889,
            current_lng: 106.700806
        };
    }

    addLog('System', `Đang gọi API Backend [${action.toUpperCase()}] chuyến xe #${rideId}...`);
    
    try {
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': `Bearer ${token}`
            },
            body: Object.keys(body).length > 0 ? JSON.stringify(body) : null
        });

        const result = await response.json();

        if (response.ok) {
            addLog('System', `API [${action}] xử lý thành công!`, result);
        } else {
            addLog('Error', `API [${action}] thất bại (${response.status})`, result);
            alert(result.message || 'Lỗi API');
        }
    } catch (error) {
        addLog('Error', `Lỗi mạng khi thực hiện ${action}`, error.message);
    }
}

// ── Event Listeners ─────────────────────────────────────────────────────────

elements.joinForm.addEventListener('submit', (e) => {
    e.preventDefault();
    connect();
});

elements.disconnectBtn.addEventListener('click', () => {
    if (socket) socket.disconnect();
});

elements.clearBtn.addEventListener('click', () => {
    elements.logList.innerHTML = '<li class="subtle" style="text-align: center; border: none;">Vui lòng vào phòng để bắt đầu nhận sự kiện...</li>';
});

elements.acceptBtn.addEventListener('click', () => callDriverApi('accept'));
elements.rejectBtn.addEventListener('click', () => callDriverApi('reject'));
elements.cancelBtn.addEventListener('click', () => callDriverApi('cancel'));
