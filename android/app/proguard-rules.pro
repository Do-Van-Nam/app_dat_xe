
# Ignore optional TLS providers (OkHttp)
########################################
-dontwarn org.bouncycastle.jsse.**
-dontwarn org.bouncycastle.jsse.provider.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**

########################################
# OkHttp internal
########################################
-dontwarn okhttp3.internal.platform.**

########################################
# IPCC SDK
########################################
-keep class com.ipccsupportsdk.** { *; }
-dontwarn com.ipccsupportsdk.**

########################################
# Permissions library (nabinbhandari)
########################################
-keep class com.nabinbhandari.android.permissions.** { *; }