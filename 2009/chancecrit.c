#include <stdio.h>

int PlayerChanceToCrit;int PlayerHitPoints;
int PlayerWeaponStart;int PlayerWeaponEnd;
int PlayerCritMultiplier;

int ComputerChanceToCrit;int ComputerHitPoints;
int ComputerWeaponStart;int ComputerWeaponEnd;
int ComputerCritMultiplier;

int damage;

int PlayerAttack() {
printf("You attack.\n");

damage = rand()%(PlayerWeaponEnd-PlayerWeaponStart) + PlayerWeaponStart;

if (testcrit(PlayerChanceToCrit) != 0) {
printf("You crit computer for %d.\n", damage*2);
ComputerHitPoints -= damage*PlayerCritMultiplier;
} else {
printf("You damage computer for %d\n", damage);
ComputerHitPoints -= damage;
}

return 0;
}

int ComputerAttack() {
damage = rand()%(ComputerWeaponEnd-ComputerWeaponStart) + ComputerWeaponStart;

if (testcrit(ComputerChanceToCrit) != 0) {
printf("- Computer crits you for %d.\n", damage*2);
PlayerHitPoints -= damage*ComputerCritMultiplier;
} else {
printf("- Computer damages you for %d\n", damage);
PlayerHitPoints -= damage;
}

return 0;

}

int testcrit(int chance) {

int x = 100/chance;

if ((rand() % x) == 0) return 1;
else return 0;

}

int main() {

char a;

srand(time(NULL));

printf("Enter your chance to crit: ");
scanf("%d", &PlayerChanceToCrit);

printf("Define your weapon attack chance (A - B) where B>A\n");
scanf("%d%d", &PlayerWeaponStart, &PlayerWeaponEnd);

printf("Define your hitpoints: ");
scanf("%d", &PlayerHitPoints);

printf("Enter critical damage multiplier (not so large number): ");
scanf("%d", &PlayerCritMultiplier);

printf("\nEnter computer chance to crit: ");
scanf("%d", &ComputerChanceToCrit);

printf("Define computer weapon attack chance (A - B) where B>A\n");
scanf("%d%d", &ComputerWeaponStart, &ComputerWeaponEnd);

printf("Define computer hitpoints: ");
scanf("%d", &ComputerHitPoints);

printf("Enter critical damage multiplier (not so large number): ");
scanf("%d", &ComputerCritMultiplier);

printf("--------------------\nPress A to attack. Special: Press B to make a double attack at the cost of 100 HP.\n");

while (a = getc(stdin)) {
if (a == 'B' || a == 'b') {
if (PlayerHitPoints <= 100) {
printf("You cannot cast doubleattack, you fail hitpoints.\n");
} else {
printf("*-* You cast doubleattack on computer.\n");
PlayerHitPoints -= 100;
PlayerAttack();
goto meow;
}
}

if (a == 'A' || a == 'a') {

meow: PlayerAttack();

if (ComputerHitPoints < 1) {
printf("Computer dies. Game over.\n");
break;
}

ComputerAttack();

if (PlayerHitPoints < 1) {
printf("You die. Game over.\n");
break;
}

printf("You are on %d HP. Computer is on %d HP.\n", PlayerHitPoints, ComputerHitPoints);

}
}

return 0;

}

