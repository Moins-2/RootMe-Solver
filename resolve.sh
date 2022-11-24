## bash script that executes 
# nuclei -u "http://challenge01.root-me.org/web-serveur/ch"+nb -t ./Web-server/
# for each nb in a list of numbers

#!/bin/bash

# list of numbers [1, 2, 52, 68]
nums=(1 2 5 52 68)

for nb in ${nums[@]}; do
    nuclei -u "http://challenge01.root-me.org/web-serveur/ch${nb}/" -t Web-server/ -silent
done
