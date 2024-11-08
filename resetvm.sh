vboxmanage controlvm ubu-vm1 poweroff
vboxmanage controlvm ubu-vm2 poweroff
vboxmanage controlvm ubu-vm3 poweroff

sleep 2

vboxmanage snapshot ubu-vm1 restore "From-the-top"
vboxmanage snapshot ubu-vm2 restore "From-the-top"
vboxmanage snapshot ubu-vm3 restore "From-the-top"

sleep 2

vboxmanage startvm ubu-vm1 --type headless
vboxmanage startvm ubu-vm2 --type headless
vboxmanage startvm ubu-vm3 --type headless
