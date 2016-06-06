#include <stdio.h>

int error() {
printf("Wrong number of talent points.\n");
system("pause");
exit(0);
}

int main() {
int arcanemind, mindmastery;
int improvedfireball, playingwithfire, firepower, empoweredfireball;
int improvedfrostbolt, piercingice, arcticwinds, empoweredfrostbolt;
float arcane, fire, frost, intellect, spelldamage;

printf("Damage Calculator by Depressed <Usual Suspects> The Maelstrom - EU\n");
printf("This program is intended to help mages in their\ntalents build decision for damage boosting.\n\n");

printf("How many points in Arcane Mind <=5: ");
scanf("%d", &arcanemind);
if (arcanemind>5) error();
printf("How many points in Mind Mastery <=5: ");
scanf("%d", &mindmastery);
if (mindmastery>5) error();

printf("How many points in Improved Fireball <=5: ");
scanf("%d", &improvedfireball);
if (improvedfireball>5) error();
printf("How many points in Playing with Fire <=3: ");
scanf("%d", &playingwithfire);
if (playingwithfire>3) error();
printf("How many points in Fire Power <=5: ");
scanf("%d", &firepower);
if (firepower>5) error();
printf("How many points in Empowered Fireball <=5: ");
scanf("%d", &empoweredfireball);
if (empoweredfireball>5) error();

printf("How many points in Improved Frostbolt <=5: ");
scanf("%d", &improvedfrostbolt);
if (improvedfrostbolt>5) error();
printf("How many points in Piercing Ice <=3: ");
scanf("%d", &piercingice);
if (piercingice>3) error();
printf("How many points in Arctic Winds <=5: ");
scanf("%d", &arcticwinds);
if (arcticwinds>5) error();
printf("How many points in Empowered Frostbolt <=5: ");
scanf("%d", &empoweredfrostbolt);
if (empoweredfrostbolt>5) error();

printf("\nHow much intellect does your char have? ");
scanf("%f", &intellect);

printf("How much spell damage does your char have? ");
scanf("%f", &spelldamage);

arcanemind *= 3; mindmastery *= 5;
improvedfireball *= 2; firepower *= 2; empoweredfireball *= 3;
improvedfrostbolt *= 2; piercingice *= 2; empoweredfrostbolt *= 2;

arcane = ((float)arcanemind/100 + 1) * (float)mindmastery/100;
fire = (1 - (float)improvedfireball/100) * ((float)firepower/100 + 1) * ((float)empoweredfireball/100 + 1) * \
((float)playingwithfire/100 + 1) - 1;
frost = (1 - (float)improvedfrostbolt/100) * ((float)empoweredfrostbolt/100 + 1) * ((float)piercingice/100 + 1) * \
((float)arcticwinds/100 + 1) - 1;

printf("\n\n(%f) Arcane Mind (%d/5) + Mind Mastery (%d/5) =\n%f bonus spell damage (%f with Improved \
Fireball/Frostbolt)\n\n", arcane, arcanemind/3, mindmastery/5, intellect*arcane, intellect*arcane*(float)90/100);

printf("(%f) Improved Fireball (%d/5) + Playing with Fire (%d/3)\n+ Fire Power (%d/5) + Empowered Fireball (%d/5) =\n\
%f bonus spell damage\n\n", fire, improvedfireball/2, playingwithfire, firepower/2, empoweredfireball/3,\
spelldamage*fire);

printf("(%f) Improved Frostbolt (%d/5) + Piercing Ice (%d/3)\n+ Arctic Winds (%d/5) + Empowered Frostbolt (%d/5) =\n\
%f bonus spell damage\n\n", frost, improvedfrostbolt/2, piercingice, arcticwinds, empoweredfrostbolt/2,\
spelldamage*frost);

printf("Note that the Arcane talents give spell damage based on intellect,\nand Fire/Frost are based on spell \
damage.\n");

system("pause");

return 0;

}
