import 'dart:io';
import 'dart:typed_data';

import 'package:rhttp/rhttp.dart';
import 'package:socks5_proxy/socks_client.dart' as soc;

class ProxyConfig {
  final String? url; // e.g., http://host:8080 or socks5://host:1080
  final String? socksHost;
  final int? socksPort;
  final String? username;
  final String? password;
  final bool useSystemProxy; // for rhttp

  const ProxyConfig({
    this.url,
    this.socksHost,
    this.socksPort,
    this.username,
    this.password,
    this.useSystemProxy = true,
  });

  bool get isSocks =>
      (url?.startsWith('socks5://') ?? false) || (socksHost != null);
}

class RhttpHolder {
  final RhttpClient client;
  RhttpHolder(this.client);
  void dispose() => client.dispose();
}

class ProxyManager {
  static Future<RhttpHolder> createRhttpClient(ProxyConfig cfg) async {
    await Rhttp.init();
    final settings = ClientSettings(
      proxySettings: cfg.url == null
          ? const ProxySettings.noProxy()
          : ProxySettings.proxy(cfg.url!),
      timeoutSettings: const TimeoutSettings(timeout: Duration(seconds: 30)),
      userAgent: 'Mozilla/5.0 (Flutter; rhttp)',
      cookieSettings: const CookieSettings(storeCookies: true),
    );
    final client = await RhttpClient.create(settings: settings);
    return RhttpHolder(client);
  }

  static HttpClient createIoClientWithSocks(ProxyConfig cfg) {
    final io = HttpClient();
    if (cfg.isSocks) {
      final host = cfg.socksHost ?? Uri.parse(cfg.url!).host;
      final port =
          cfg.socksPort ??
          int.tryParse(Uri.parse(cfg.url!).port.toString()) ??
          1080;
      final proxies = [
        soc.ProxySettings(
          InternetAddress.tryParse(host) ?? InternetAddress(host),
          port,
          username: cfg.username,
          password: cfg.password,
        ),
      ];
      soc.SocksTCPClient.assignToHttpClient(io, proxies);
    } else if (cfg.url != null && cfg.url!.startsWith('http')) {
      // dart:io HttpClient doesn't support HTTP proxies natively in a cross-platform way.
      // Prefer rhttp for HTTP/HTTPS proxies.
    }
    io.connectionTimeout = const Duration(seconds: 20);
    return io;
  }

  static Future<(int status, int len)> testHttpWithRhttp(
    RhttpHolder holder,
    String url,
  ) async {
    final resp = await holder.client.getBytes(url);
    return (resp.statusCode, resp.body.lengthInBytes);
  }

  static Future<(int status, int len)> testHttpWithIo(
    HttpClient io,
    String url,
  ) async {
    final req = await io.getUrl(Uri.parse(url));
    final resp = await req.close();
    final bytes = await resp
        .fold<BytesBuilder>(BytesBuilder(), (b, d) => b..add(d))
        .then((b) => b.takeBytes());
    io.close(force: true);
    return (resp.statusCode, bytes.length);
  }
}
