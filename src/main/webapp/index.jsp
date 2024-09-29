<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>File Hash Calculator</title>
    <script src="${pageContext.request.contextPath}/libs/sha256.min.js"></script>
</head>
<body>
<h1>File SHA-256 Hash Calculator</h1>

<input type="file" id="fileInput" />
<button id="calculateBtn">Calculate SHA-256</button>

<p id="hashOutput">File hash will appear here...</p>

<script>
    const fileInput = document.getElementById('fileInput');
    const calculateBtn = document.getElementById('calculateBtn');

    calculateBtn.addEventListener('click', function() {
        const file = fileInput.files[0];  // Get the first selected file

        if (file) {
            const reader = new FileReader();
            reader.readAsArrayBuffer(file);

            // When file reading is finished
            reader.onload = function(e) {
                const arrayBuffer = e.target.result;  // Get the ArrayBuffer result
                const hash = sha256(arrayBuffer);
                document.getElementById('hashOutput').textContent = `SHA-256: ` + hash;
            };

            reader.onerror = function() {
                console.error('Error reading file');
                document.getElementById('hashOutput').textContent = "Error reading file.";
            };
        } else {
            document.getElementById('hashOutput').textContent = "Please select a file first.";
        }
    });
</script>
</body>
</html>
