#include <stdio.h>

int main() {
float fire = (float)6059/200000; //Talent build number.
float firecrit, spellhit, spellcrit, spellhaste;

printf("\"Casting Fireballs on Boss with 17%% chance to resist\" simulator written by BoR0 (Patch 2.3)\n\
Assumes: Level 70, 5/5 Improved Fireball, 3/3 Playing with Fire, 5/5 Fire Power, 5/5 Empowered Fireball, 3/3 \
Elemental Precision\n\n");

printf("Enter your spell damage: ");
scanf("%f", &firecrit);

fire = (fire+1)*firecrit + (float)808.5; //Calculate the average damage
firecrit = fire*(float)150/100; //Calculate the critical strike (150%)

printf("Enter your spell hit (12.6) rating: ");
scanf("%f", &spellhit);
if (spellhit > 163.8) {
printf("You're above the spell hit cap. You fale.\n");
spellhit = 163.8;
}
spellhit *= (float)100/1260; spellhit = 86 + spellhit;

printf("Enter your spell crit (22.1) rating: ");
scanf("%f", &spellcrit);
spellcrit *= (float)100/2210;

printf("Enter your spell haste (15.7) rating: ");
scanf("%f", &spellhaste);
spellhaste *= (float)1/1570;

fire = ((100-spellcrit)*fire + spellcrit*firecrit)/100;
fire = (spellhit*fire - (100-spellhit)*fire)/100;
fire/= 3/(1+spellhaste);

printf("\n- Fireball does %f DPS.\n", fire);

return 0;

}
