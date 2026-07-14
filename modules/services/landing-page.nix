{pkgs, ...}: let
  indexHtml = ''
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>jazzkid.xyz</title>

      <link rel="manifest" href="/manifest.json">
      <meta name="theme-color" content="#0d0d0d">
      <meta name="apple-mobile-web-app-capable" content="yes">
      <meta name="apple-mobile-web-app-status-bar-style" content="black">
      <meta name="apple-mobile-web-app-title" content="Dashboard">

      <style>
        :root { color-scheme: dark; }
        body {
          background: #0d0d0d;
          color: #d4d4d4;
          font-family: ui-monospace, monospace;
          max-width: 800px;
          margin: 3rem auto;
          padding: 0 1.5rem;
        }
        h1 { color: #fff; font-size: 1.5rem; }
        h2 {
          color: #888;
          font-size: 0.8rem;
          text-transform: uppercase;
          letter-spacing: 0.1em;
          margin-top: 2rem;
        }
        a {
          color: #7aa2f7;
          text-decoration: none;
        }
        a:hover { text-decoration: underline; }
        .service {
          display: flex;
          align-items: baseline;
          gap: 0.75rem;
          padding: 0.4rem 0;
        }
        .name { min-width: 180px; }
        .desc { color: #666; font-size: 0.85rem; }
      </style>
    </head>
    <body>
      <h1>jazzkid.xyz</h1>

      <h2>Media</h2>
      <div class="service"><span class="name"><a href="https://jellyfin.jazzkid.xyz">Jellyfin</a></span><span class="desc">media player</span></div>
      <div class="service"><span class="name"><a href="https://jellyseerr.jazzkid.xyz">Jellyseerr</a></span><span class="desc">media requests</span></div>
      <div class="service"><span class="name"><a href="https://prowlarr.jazzkid.xyz">Prowlarr</a></span><span class="desc">indexer manager</span></div>
      <div class="service"><span class="name"><a href="https://radarr.jazzkid.xyz">Radarr</a></span><span class="desc">movies</span></div>
      <div class="service"><span class="name"><a href="https://sonarr.jazzkid.xyz">Sonarr</a></span><span class="desc">tv shows</span></div>
      <div class="service"><span class="name"><a href="https://lidarr.jazzkid.xyz">Lidarr</a></span><span class="desc">music</span></div>
      <div class="service"><span class="name"><a href="https://bazarr.jazzkid.xyz">Bazarr</a></span><span class="desc">subtitles</span></div>
      <div class="service"><span class="name"><a href="https://transmission.jazzkid.xyz">Transmission</a></span><span class="desc">torrents</span></div>

      <h2>Tools</h2>
      <div class="service"><span class="name"><a href="https://notes.jazzkid.xyz">Notes</a></span><span class="desc">silverbullet wiki</span></div>
      <div class="service"><span class="name"><a href="https://cachix.jazzkid.xyz">Cache</a></span><span class="desc">nix binary cache</span></div>

      <h2>Hosts</h2>
      <div class="service"><span class="name"><a href="https://nas.jazzkid.xyz">jazznas</a></span><span class="desc">this machine</span></div>
      <div class="service"><span class="name"><a href="https://pc.jazzkid.xyz">jazzpc</a></span><span class="desc">desktop</span></div>
      <div class="service"><span class="name"><a href="https://dev.jazzkid.xyz">jazzserver</a></span><span class="desc">vps</span></div>

      <script>
        if ('serviceWorker' in navigator) {
          navigator.serviceWorker.register('/sw.js');
        }
      </script>
    </body>
    </html>
  '';

  iconSvg = ''
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 192 192">
      <rect width="192" height="192" fill="#0d0d0d" rx="24"/>
      <text x="96" y="116" text-anchor="middle" font-family="ui-monospace,monospace" font-size="64" font-weight="bold" fill="#7aa2f7">JK</text>
    </svg>
  '';

  manifest = ''
    {
      "name": "Jazzkid Dashboard",
      "short_name": "jazzkid",
      "start_url": "/",
      "display": "standalone",
      "theme_color": "#0d0d0d",
      "background_color": "#0d0d0d",
      "icons": [
        {
          "src": "/icon.svg",
          "sizes": "any",
          "type": "image/svg+xml"
        }
      ]
    }
  '';

  serviceWorker = ''
    const CACHE = "jazzkid-v1";
    const ASSETS = ["/", "/manifest.json", "/icon.svg"];

    self.addEventListener("install", (e) => {
      e.waitUntil(
        caches.open(CACHE).then((cache) => cache.addAll(ASSETS))
      );
    });

    self.addEventListener("fetch", (e) => {
      e.respondWith(
        caches.match(e.request).then((cached) => {
          const fetched = fetch(e.request).then((res) => {
            if (res.ok) {
              const clone = res.clone();
              caches.open(CACHE).then((cache) => cache.put(e.request, clone));
            }
            return res;
          });
          return cached || fetched;
        })
      );
    });

    self.addEventListener("activate", (e) => {
      e.waitUntil(
        caches.keys().then((keys) =>
          Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k)))
        )
      );
    });
  '';
in {
  services.nginx.virtualHosts."home.jazzkid.xyz" = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
    root = pkgs.runCommand "landing-page" {} ''
      mkdir -p $out
      cp ${pkgs.writeText "index.html" indexHtml} $out/index.html
      cp ${pkgs.writeText "icon.svg" iconSvg} $out/icon.svg
      cp ${pkgs.writeText "manifest.json" manifest} $out/manifest.json
      cp ${pkgs.writeText "sw.js" serviceWorker} $out/sw.js
    '';
    locations = {
      "/sw.js".extraConfig = ''
        add_header Cache-Control "no-cache";
      '';
      "/".extraConfig = ''
        allow 192.168.1.0/24;
        allow 100.64.0.0/10;
        allow fd7a:115c:a1e0::/48;
        allow 127.0.0.1;
        allow ::1;
        deny all;
      '';
    };
  };
}
