#!/bin/sh
destroy()
{
    terraform destroy -var-file="./../config.tfvars" -auto-approve
}

apply(){
    terraform apply -var-file="./../config.tfvars" -auto-approve                                                                
}

main(){
    destroy
    apply
    destroy
}

main
