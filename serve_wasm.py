import http.server
import os

class WasmHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cross-Origin-Embedder-Policy', 'credentialless')
        self.send_header('Cross-Origin-Opener-Policy', 'same-origin')
        super().end_headers()

os.chdir('build/web')
server = http.server.HTTPServer(('0.0.0.0', 8080), WasmHandler)
print('Serving at http://localhost:8080')
server.serve_forever()
