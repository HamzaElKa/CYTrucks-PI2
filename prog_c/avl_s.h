#ifndef AVL_S_H
#define AVL_S_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef struct arbre
{
  int id;
  float max;
  float min;
  float moy;
  float dif;
  struct arbre *fg;
  struct arbre *fd;
  int eq;
}arbre;
typedef struct arbre *parbre;
typedef struct
{
int id;
float max;
float min;
float moy;
float dif;
}trajetf;
int max2(int a, int b);
int max3(int a, int b, int c);
int min2(int a, int b);
int min3(int a, int b, int c);
parbre creerarbre(trajetf* d);
parbre insertionAVL(parbre a, trajetf* d, int *h);
parbre rotationgauche(parbre a);
parbre rotationdroite(parbre a);
parbre doublerotationgauche(parbre a);
parbre doublerotationdroite(parbre a);
parbre equilibrerAVL(parbre a);
void infixeInverse(parbre a, FILE* fichier_temp_s);
void traitement_s(char *fichier);
#endif
