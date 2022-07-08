# Resolving DNS when using a VPN on WSL

## Fix

link for full explanation : https://unix.stackexchange.com/questions/589683/wsl-dns-not-working-when-connected-to-vpn

```
sudo vi /etc/wsl.conf
```
> [network]   
> generateResolvConf = false

```
sudo rm /etc/resolv.conf 
sudo vi /etc/resolv.conf 
```

> search    your.domain.com #Change it to your search domain company if needed  
> nameserver    x.x.x.x     #First DNS used by your VPN  
> nameserver    x.x.x.x     #Second DNS used by your VPN  
> nameserver    y.y.y.y     #Your normal local DNS  

Reboot your WSL machine to apply changes and you're done !  
  
## Potential other related issue

*At this point, DNS should work when using VPN.*    
*But you might face a weird issue where DNS resolution are really slow when using the VPN (It happened to me on Ubuntu, but not on Arch).*    
*Despite all weird and sketchy "solutions" I found on the internet, I couldn't found one that actually worked for me.*    
*But I found an acceptable workaround, which is reducing the DNS timeout to 0 sec.*    
*This way, the system will not wait any time before going reaching the next DNS server if the previous one doesn't provide an appropriate response.*    

```
sudo vi /etc/resolv.conf #Edit the file
```

> search    your.domain.com   
> **options timeout:0**  
> nameserver    x.x.x.x       
> nameserver    x.x.x.x  
> nameserver    y.y.y.y  
  
Reboot your WSL machine to apply changes
  
After that, all your DNS resolutions will only take about 1 to 2 seconds (not better then "instantly" but still, better then 5 to 10 sec) !  
I'll update this file if I ever find a real fix to that issue, but that only happened to me with WSL Ubuntu and I'm not using it anymore.
