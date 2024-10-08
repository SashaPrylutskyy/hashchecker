let fileInput = document.getElementById("file-input");
let fileList = document.getElementById("files-list");
let numOfFiles = document.getElementById("num-of-files");

fileInput.addEventListener("change", () => {
    fileList.innerHTML = ""; // Clear the list
    numOfFiles.textContent = `${fileInput.files.length} Files Selected`;

    for (const file of fileInput.files) {
        createFileDescription(file);
        calculateHashWithProgress(file);
    }
});

function createFileDescription(file) {
    let listItem = document.createElement("li");
    // let fileName = file.name;
    let fileSize = (file.size / 1024).toFixed(1);

    // Display file size in MB if larger than 1024 KB
    let sizeDisplay = `${fileSize} KB`;
    if (fileSize >= 1024) {
        sizeDisplay = `${(fileSize / 1024).toFixed(1)} MB`;
    }

    // Create a div for file description and progress bar
    listItem.innerHTML = `
        <div class="content">
            <div class="file-info" id="file-info-${file.name}">
                <p class="left" id="file-name"><strong>${file.name}</strong></p>
                <p class="right" id="file-size">${sizeDisplay}</p>
            </div>
            <div class="progress-container">
                <div class="progress-bar" id="progress-bar-${file.name}">0%</div>
            </div>
            <p id="hashOutput-${file.name}">Calculating hash...</p><br>
            <input class="submit-button" type="submit" value="SAVE TO THE LIST" disabled 
                    id="submit-button-${file.name}" onclick="upload('${file.name}', ${fileSize})">
        </div>
        `;
    fileList.appendChild(listItem);
}

function upload(fileName, fileSize) {
    const hashOutputElement = document.getElementById("hashOutput-" + fileName).innerText.split(' ');
    const hashcode = hashOutputElement[1];
    let button = document.getElementById("submit-button-" + fileName);

    fetch("/upload", {
        method: "POST",
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({fileName: fileName, hashcode: hashcode, fileSize: fileSize}),
    })
        .then(response => response.json())
        .then(data => {
            button.style.fontWeight = "bold";
            button.style.color = "#3a3a3a";
            button.disabled = true;

            if (data.status === "success") {
                button.textContent = "Saved";
                button.style.backgroundColor = "#46fc9e3d";
            }
            else if (data.status === "failed") {
                button.textContent = "Failed: " + data.message;
                button.style.backgroundColor = "#da674a";
            }
        })
        .catch(e => {
            button.textContent = "Failed: " + e;
            button.style.backgroundColor = "#da674a";
        });
}

function calculateHashWithProgress(file) {
    let reader = new FileReader();
    let chunkSize = 2 * 1024 * 1024; // 2MB chunks
    let offset = 0;
    let sha256 = CryptoJS.algo.SHA256.create();
    let totalChunks = Math.ceil(file.size / chunkSize);

    let progressBar = document.getElementById(`progress-bar-${file.name}`);
    let hashOutput = document.getElementById(`hashOutput-${file.name}`);
    let submitButton = document.getElementById(`submit-button-${file.name}`);

    function readNextChunk() {
        let chunk = file.slice(offset, offset + chunkSize);
        reader.readAsArrayBuffer(chunk);
    }

    reader.onload = function (e) {
        let wordArray = CryptoJS.lib.WordArray.create(e.target.result);
        sha256.update(wordArray);

        // Update progress
        offset += chunkSize;
        let progress = Math.min((offset / file.size) * 100, 100);
        progressBar.style.width = progress + '%';
        progressBar.textContent = Math.floor(progress) + '%';

        if (offset < file.size) {
            readNextChunk(); // Read the next chunk
        } else {
            // Finalize the hash and display it
            let hash = sha256.finalize().toString(CryptoJS.enc.Hex);
            hashOutput.textContent = `SHA-256: ${hash}`;

            // Enable the submit button when the hash is calculated
            submitButton.disabled = false;
        }
    };

    reader.onerror = function () {
        console.error('Error reading file');
        hashOutput.textContent = "Error reading file.";
    };

    // Start reading the first chunk
    readNextChunk();
}
