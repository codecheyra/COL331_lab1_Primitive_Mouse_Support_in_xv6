#include "types.h"
#include "defs.h"
#include "x86.h"
#include "mouse.h"
#include "traps.h"

// Wait until the mouse controller is ready for us to send a packet
void mousewait_send(void) 
{
    //wait until bit 1 of register is clear
    while((inb(0x64) & 0x02) != 0x00){
        ;
    }
    return;
}

// Wait until the mouse controller has data for us to receive
void 
mousewait_recv(void) 
{
    while((inb(0x64) & 0x01) == 0x00){
        ;
    }
    return;
}

void 
mousecmd(uchar cmd) 
{
    mousewait_send();
    outb(0x64, 0xD4);
    mousewait_send();
    outb(0x60, cmd);
    mousewait_recv();
    inb(0x60);
    return;
}

// Send a one-byte command to the mouse controller, and wait for it
//
void
mouseinit(void)
{
    // Implement your code here
    //wait until the controller is ready to receive packets
    mousewait_send();
    //send the command byte 0x20 to the control port (0xA8)
    outb(0x64, 0xA8);
    // interupts
    mousewait_send();
    outb(0x64, 0x20);
    mousewait_recv();
    uchar status = inb(0x60);
    uchar newstatus = status | 0x02;
    mousewait_send();
    outb(0x64, 0x60);
    mousewait_send();
    outb(0x60, newstatus);
    mousecmd(0xF6);
    mousecmd(0xF4);
    ioapicenable(IRQ_MOUSE, 0);
    //ensure line number 71 in lab1.md
    cprintf("Mouse has been initialized\n");
}

void
mouseintr(void)
{
    // Implement your code here
    // uchar status;
    uchar data;
    
    // mousewait_recv();
    // status = inb(0x64);
    // Check if there is data available on the data port (0x60)
    // if((status & 0x01) == 0x01){

        mousewait_recv();
    data = inb(0x60);

    if(((data & 0x01) == 0x01)){
        cprintf("LEFT\n");
    }
    if((data & 0x02) == 0x02){
        cprintf("RIGHT\n");
    }
    if((data & 0x04) == 0x04){
        cprintf("MID\n");
    }
    mousewait_recv();
    inb(0x60);
    mousewait_recv();
    inb(0x60);
    
}