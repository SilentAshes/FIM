# Automated File Integrity Monitoring (FIM) with PowerShell 🛡️

This repository contains a PowerShell script for automated File Integrity Monitoring (FIM). It monitors specified files for unauthorized changes, providing alerts.

## Features ✨

* **Automated Monitoring:** Continuously monitors files within a designated directory.
* **Baseline Creation:** Generates a baseline of file hashes for comparison.
* **Change Detection:** Detects file modifications, additions, and deletions.
* **Real-time Alerts:** Notifies the user of changes via console output.

## Getting Started 🚀

### Prerequisites

* Windows with PowerShell 5.1 or later.
* Administrator privileges (for monitoring protected files).

### Installation

1.  Clone the repository:

    ```bash
    git clone [https://github.com/SilentAshes/FIM.git](https://github.com/SilentAshes/FIM.git)
    ```

### Usage

1.  **Place Files to Monitor:** Place the files you wish to monitor inside the `files` directory within the cloned repository.

2.  **Run the Script:** Open PowerShell and navigate to the directory where you cloned the repository. Execute the `FIM.ps1` script.

3.  **Choose an Action:**
    * **A) Collect New Baseline:** This option calculates the SHA512 hash of each file in the `files` directory and stores them in `baseline.txt`. This is your initial reference point.
    * **B) Begin Monitoring Files with Saved Baseline:** This option continuously monitors the files against the saved `baseline.txt`. It will alert you if any file is modified, added, or deleted.

    ```powershell
    .\FIM.ps1
    ```

4.  **Monitoring:** If you choose option B, the script will continuously monitor the files. Changes will be displayed in the PowerShell console.

### Code Explanation 📜

* **`calculate-file-hash($filepath)`:** This function calculates the SHA512 hash of a given file.
* **`Erase-Baseline-IF-Exists()`:** This function checks if `baseline.txt` exists and deletes it if it does.
* **Baseline Creation (Option A):**
    * Deletes the existing `baseline.txt` (if any).
    * Recursively gets all files from the `files` directory.
    * Calculates the SHA512 hash of each file.
    * Stores the file path and hash in `baseline.txt` (e.g., `filepath|hash`).
* **Monitoring (Option B):**
    * Loads the file paths and hashes from `baseline.txt` into a dictionary (`$fileHashDicti`).
    * Continuously monitors the `files` directory (every 1 second).
    * Calculates the SHA512 hash of each file.
    * Compares the current hash with the baseline hash.
    * Alerts the user if a file is modified, added, or deleted.
    * Alerts user if a file from the baseline has been deleted.

### Notes

* The script uses SHA512 hashing for file integrity checks.
* Alerts are displayed in the PowerShell console.
* The script monitors all files within the `files` directory recursively.
* The monitoring loop runs indefinitely until manually stopped (Ctrl+C).

### Contributing 🤝

Contributions are welcome! Please fork the repository and submit a pull request.

### License

This project is licensed under the [MIT License](LICENSE).
