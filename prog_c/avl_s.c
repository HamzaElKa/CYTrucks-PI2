#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct arbre
{
  int id;
  float max;
  float min;
  struct arbre *fg;
  struct arbre *fd;
  int eq;
}arbre;
typedef struct arbre *parbre;
typedef struct 
{
  int id;
  float distance;
}trajet;

typedef struct
{
int id;
float max;
float min;
float moy;
}trajetf;
parbre creerarbre(trajet d)
{
    arbre *nouveau = malloc(sizeof(arbre));
    if (nouveau == NULL)
    {
        printf("Erreur d'allocation.\n");
        exit(1);
    }
    nouveau->id=d.id;
    nouveau->max=0;
    nouveau->min=0;
    nouveau->fg = NULL;
    nouveau->fd = NULL;
    nouveau->eq=0;
    return nouveau;
}
parbre insertionAVL(parbre a, trajet d, int *h)
{
if(a==NULL){
*h=1;
return creerarbre(d);
}
else if(d.id < a->id){
a->fg=insertionAVL(a->fg,d,h);
*h=-*h;
}
else if(d.id > a->id){
a->fd=insertionAVL(a->fd,d,h);
}
else{
*h=0;
if(d.distance > a->max){
a->max=d.distance;
}
if(d.distance < a->min){
a->min=d.distance;
}}
if(*h !=0){
a->eq=a->eq+*h;
if(a->eq==0){
*h=0;
}else{
*h=1;
}}
return a;
}
parbre rotationgauche(parbre a){
parbre pivot=malloc(sizeof(arbre));
int eq_a=0;
int eq_p=0;
pivot=a->fd;
a->fd=pivot->fg;
pivot->fg=a;
eq_a=a->eq;
eq_p=pivot->eq;
a->eq=eq_a-max2(eq_p,0)-1;
pivot->eq=min3(eq_a-2,eq_a+eq_p-2,eq_p-1);
a=pivot;
return a;
}
parbre rotationdroite(parbre a){
parbre pivot=malloc(sizeof(arbre));
int eq_a=0;
int eq_p=0;
pivot=a->fg;
a->fg=pivot->fd;
pivot->fd=a;
eq_a=a->eq;
eq_p=pivot->eq;
a->eq=eq_a-min2(eq_p,0)+1;
pivot->eq=max3(eq_a+2,eq_a+eq_p+2,eq_p+1);
a=pivot;
return a;
}

parbre doublerotationgauche(parbre a){
a->fd=rotationdroite(a->fd);
return rotationgauche(a);
}

parbre doublerotationdroite(parbre a){
a->fg=rotationgauche(a->fg);
return rotationdroite(a);
}

parbre equilibrerAVL(parbre a){
if(a->equilibre>=2){
if(a->fd->equilibre>=0){
return roationgauche(a);
}else{
return doublerotationgauche(a);
}}
else if(a->equilibre<=-2){
if(a->fg->equilibre<=0){
return rotatiodroite(a);
}else{
return doublerotationdroite(a);
}}
return a;
}
int max2(int a, int b) {
    return (a > b) ? a : b;
}
int max3(int a, int b, int c) {
    int max = a;
    if (b > max) {
        max = b;
    }
    if (c > max) {
        max = c;
    }
    return max;
}
int min2(int a, int b) {
    return (a < b) ? a : b;
}
int min3(int a, int b, int c) {
    int min = a;
    if (b < min) {
        min = b;
    }
    if (c < min) {
        min = c;
    }
    return min;
}
void postfixe(parbre a, trajetf* tableau, int* i) 
{
  if (a == NULL)
  {
    return;
  }
  postfixe(a->fd,tableau,i);
  postfixe(a->fg,tableau,i);
  tableau[*i].id= node->id;
  tableau[*i].max = node->max;
  tableau[*i].min = node->min;
  tableau[*i].moy = (node->max - node->min)/2;
  (*i)++;
}
void traitement_s(char *fichier){
  FILE* file = fopen(fichier, "r");
  if (file == NULL)
  {
    perror("ERREUR : impossible d'ouvrir le fichier csv");
    exit(1);
  }
  char ligne[1024];
  fgets(ligne, ligne_taille_max, file);
  trajet courant;
  int *h = 0;
  arbre *nouveau=malloc(sizeof(arbre));
  while (fgets(ligne, ligne_taille_max, file) != NULL)
    {
      sscanf(ligne, "%d;%*[^;];%*[^;];%*[^;];%f;%*[^;]", courant.id, courant.distance);
      node = insertionAVL(nouveau, courant, h); 
nouveau = equilibrerAVL(nouveau);
    }

  fclose(file);
  trajetf* tableau[300];
  int i = 0;
  postfixe(nouveau,tableau,i);
  free(nouveau);
  FILE* fichier_temp_s;
  fichier_temp_s = fopen("temp/data_s.txt", "w");
    if (fichier_temp == NULL)
    {
      perror("ERREUR : impossible d'ouvrir le fichier csv");
      exit(2);
    }
    for(int y=0; y<=i; y++)
      {
        fprintf(fichier_temp_s, "%d;%f;%f;%f", tableau[y]->id, tableau[y]->min, tableau[y]->max, tableau[y]->moy);
      }
    fclose(fichier_temp_s);
}
int main(int argc, char *argv[]) {
  char *chemin_csv = argv[1]; 
  for(i; i<argc; i++)      
  {
    if(strcmp(argv[i], "-t") == 0)
    {
      traitement_t(chemin_csv);
    }

    if(strcmp(argv[i], "-s") == 0)
    {
      traitement_s(chemin_csv);
    }
  }
return 0;
}
