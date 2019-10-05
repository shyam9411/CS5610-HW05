# Memory

The file in this repo have been forked from: https://github.com/NatTuck/scratch-2019-09/tree/master/5610/08/hangman and the intent of this is to successfully create a react app for the memory game with the computation logic for a state residing in Elixir. The game associates each tile with a letter from A - Z and upon matching corresponding tiles, it accepts them. Incorrect matching is reverted back. The total score is computed based on the clicks made to find all such pairs.

Deployment steps were followed from: http://ccs.neu.edu/home/ntuck/courses/2019/09/cs5610/notes/04-phoenix-frontend/notes.html and also made the following changes

```
Edit the included hw5.service file to make sure it's correct.
Copy it to /etc/systemd/system
Enable it with "sudo systemctl enable hw5"
Start the service with "sudo service hw5 start".
```

Once the following is done, the app would start to run automatically upon launching intended domain.

The domain for this assignement is: http://memory2.neu-webapps.space/
