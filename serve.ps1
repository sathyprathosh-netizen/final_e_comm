# PowerShell Local HTTP Server for GG Fashion E-Commerce
$port = 8080
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")

try {
    $listener.Start()
    Write-Host "--------------------------------------------------------" -ForegroundColor Green
    Write-Host " GG Fashion Local Server is running!" -ForegroundColor Green
    Write-Host " Open your browser and go to: http://localhost:$port/" -ForegroundColor Cyan
    Write-Host " Press Ctrl+C in this terminal to stop the server." -ForegroundColor Yellow
    Write-Host "--------------------------------------------------------" -ForegroundColor Green

    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $path = $request.Url.LocalPath
        if ($path -eq "/") {
            $path = "/index.html"
        }

        # Safe path resolution
        $filePath = Join-Path (Get-Location) $path.TrimStart('/')
        
        if (Test-Path $filePath -PathType Leaf) {
            $bytes = [System.IO.File]::ReadAllBytes($filePath)
            
            # Basic MIME type detection
            $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
            $contentType = "text/html; charset=utf-8"
            if ($ext -eq ".css") { $contentType = "text/css" }
            elseif ($ext -eq ".js") { $contentType = "application/javascript" }
            elseif ($ext -eq ".png") { $contentType = "image/png" }
            elseif ($ext -eq ".jpg" -or $ext -eq ".jpeg") { $contentType = "image/jpeg" }
            elseif ($ext -eq ".gif") { $contentType = "image/gif" }
            elseif ($ext -eq ".svg") { $contentType = "image/svg+xml" }
            elseif ($ext -eq ".json") { $contentType = "application/json" }

            $response.ContentType = $contentType
            $response.ContentLength64 = $bytes.Length
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            $response.StatusCode = 404
            $errBytes = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found: The file $path could not be found.")
            $response.ContentType = "text/plain"
            $response.ContentLength64 = $errBytes.Length
            $response.OutputStream.Write($errBytes, 0, $errBytes.Length)
        }
        $response.Close()
    }
} catch {
    Write-Host "An error occurred starting or running the server: $_" -ForegroundColor Red
} finally {
    if ($listener -ne $null) {
        $listener.Stop()
    }
}
