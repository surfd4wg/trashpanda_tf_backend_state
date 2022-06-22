#!/bin/bash
#export MYjumpserverIP="$(terraform output -json  jumpserverIP | jq -r '.[0]')"
#export MYjumpserverIP="ec2-52-1-214-65.compute-1.amazonaws.com"
export MYjumpserverEIP="$(terraform output -json  jumpserverEIP | jq -r '.[0]')"
export MYjumpserverUSER="$(terraform output -raw jumpserverUSER)"
#export MYjumpserverUSER="ec2-user"
export MYjumpserverKEY="$(terraform output -raw jumpserverKEY)"
export MYjumpserverLOGIN="ssh -i $MYjumpserverKEY $MYjumpserverUSER@$MYjumpserverEIP"
mySSH() {
    #"ssh -i $MYjumpserverKEY $MYjumpserverUSER@$MYjumpserverIP"
    eval "$MYjumpserverLOGIN"
}

# run it
mySSH
