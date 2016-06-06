#include <stdio.h>

//Arcane Missiles 784 mana
//AB1 195 mana
//AB2 341 mana (536 mana)
//AB3 487 mana (1023 mana)
//AB4 633 mana (1656 mana)

int main() {
float am, ab, amcrit, abcrit, spellhit, spellcrit, spellhaste, dpm;
float spellcast[4];

printf("\"Casting AM/AB on Boss with 17%% chance to resist\" simulator written by BoR0 (Patch 2.3)\n\
Assumes: Level 70\n\n");

printf("Enter the damage one Arcane Missile hits for: ");
scanf("%f", &am);

am *= 5;

printf("Enter the damage one Arcane Missile crits for: ");
scanf("%f", &amcrit);

printf("Enter the damage one Arcane Blast hits for: ");
scanf("%f", &ab);

printf("Enter the damage one Arcane Blast crits for: ");
scanf("%f", &abcrit);

printf("\nEnter your spell hit (12.6) rating: ");
scanf("%f", &spellhit);
if (spellhit > 75.6) {
printf("You're above the spell hit cap. You fale.\n");
spellhit = 75.6;
}
spellhit *= (float)100/1260; spellhit = 93 + spellhit;

printf("Enter your spell crit (22.1) rating: ");
scanf("%f", &spellcrit);
spellcrit *= (float)100/2210;

printf("Enter your spell haste (15.7) rating: ");
scanf("%f", &spellhaste);
spellhaste *= (float)1/1570;

spellcast[0] = 5/(1 + spellhaste); //Arcane Missiles
if (spellcast[0] < 1.5) spellcast[0] = 1.5;
spellcast[1] = 2.5/(1 + spellhaste); //AB1
if (spellcast[1] < 1.5) spellcast[1] = 1.5;
spellcast[2] = 2.17/(1 + spellhaste); //AB2
if (spellcast[2] < 1.5) spellcast[2] = 1.5;
spellcast[3] = 1.83/(1 + spellhaste); //AB3
if (spellcast[3] < 1.5) spellcast[3] = 1.5;

am = ((100-spellcrit)*am + spellcrit*amcrit)/100;
am = (spellhit*am - (100-spellhit)*am)/100;
dpm = am/784;
am /= spellcast[0];
printf("\n- Arcane Missiles does %f DPS/%f DPM.\n", am, dpm);

spellcrit += 6; // Arcane Impact

am = ((100-spellcrit)*ab + spellcrit*abcrit)/100;
am = (spellhit*am - (100-spellhit)*am)/100;
dpm = am/633;
am /= 1.5;
printf("- Arcane Blast (spam rank 4) does %f DPS/%f DPM.\n", am, dpm);

am = ((100-spellcrit)*ab + spellcrit*abcrit)/100;
am = (spellhit*am - (100-spellhit)*am)/100;
dpm = am/195;
am /= spellcast[1];
printf("- 1Arcane Blast does %f DPS/%f DPM.\n", am, dpm);

am = ((100-spellcrit)*2*ab + spellcrit*2*abcrit)/100;
am = (spellhit*am - (100-spellhit)*am)/100;
dpm = am/536;
am /= spellcast[1] + spellcast[2];
printf("- 2Arcane Blast does %f DPS/%f DPM.\n", am, dpm);

am = ((100-spellcrit)*3*ab + spellcrit*3*abcrit)/100;
am = (spellhit*am - (100-spellhit)*am)/100;
dpm = am/1023;
am /= spellcast[1] + spellcast[2] + spellcast[3];
printf("- 3Arcane Blast does %f DPS/%f DPM.\n", am, dpm);

am = ((100-spellcrit)*4*ab + spellcrit*4*abcrit)/100;
am = (spellhit*am - (100-spellhit)*am)/100;
dpm = am/1656;
am /= spellcast[1] + spellcast[2] + spellcast[3] + 1.5;
printf("- 4Arcane Blast does %f DPS/%f DPM.\n", am, dpm);

return 0;

}
