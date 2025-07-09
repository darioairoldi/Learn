## PROBLEM DESCRIPTION
cloning a repository with Visual Studio fails with the following error:

| Clone repo | Fatal error |
|--------|--------|
| ![Clone Repository](<images/001.01 clonerepo.png>) | ![Fatal Error](<images/001.02 fatal error.png>) |

## ANALYSIS

Visual studio has grants 
to the folder as I could create a file 
![alt text](<images/002.01 visual studio file access.png>)

the issue also happens running visual studio with admin rights 
![alt text](<images/002.02 admin rights.png>)

cloning the repo unders the user profile WORKS! 
![alt text](<images/002.03 clone under user profile.png>)

cloning it under drive e: fails as shown above.

## SOLUTION
cloning the repo from the command line or by means of Visual studio code works fine!
![alt text](<images/003.01a clone with vscode.png>)