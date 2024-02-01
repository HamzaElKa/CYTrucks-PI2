#include "avl_s.h"


int max2(int a, int b) {
    return (a > b) ? a : b;
}
int max3(int a, int b, int c) {
    return max2(max2(a,b),c);
}
int min2(int a, int b) {
    return (a < b) ? a : b;
}
int min3(int a, int b, int c) {
    return min2(min2(a,b),c);
}
parbre creerarbre(trajetf* d)
{
    arbre *nouveau = malloc(sizeof(arbre));
    if (nouveau == NULL)
    {
        printf("Erreur d'allocation.\n");
        exit(1);
    }
    nouveau->id=d->id;
    nouveau->max=d->max;
    nouveau->min=d->min;
    nouveau->moy=d->moy;
    nouveau->dif=d->dif;
    nouveau->fg = NULL;
    nouveau->fd = NULL;
    nouveau->eq=0;
    return nouveau;
}
parbre insertionAVL(parbre a, trajetf* d, int *h)
{
if (d==NULL){
return a;
}
    if (a == NULL) {
        *h = 1;
        return creerarbre(d);
    } else if (d->dif < a->dif) {
        a->fg = insertionAVL(a->fg, d, h);
        *h = -*h;
    } else if (d->dif > a->dif) {
        a->fd = insertionAVL(a->fd, d, h);
    } else if (d->dif==a->dif) {
        *h = 0;
        if (d->max > a->max) {
            a->max = d->max;
        }
        if (d->min < a->min) {
            a->min = d->min;
        }
    }
    if (*h != 0) {
        a->eq = a->eq + *h;
        if (a->eq == 0) {
            *h = 0;
        } else {
            *h = 1;
        }
    }
    return a;
}
parbre rotationgauche(parbre a){
if(a==NULL){
return a;
}
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
if(a==NULL){
return a;
}
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
if(a==NULL){
return a;
}
a->fd=rotationdroite(a->fd);
return rotationgauche(a);
}

parbre doublerotationdroite(parbre a){
if(a==NULL){
return a;
}
a->fg=rotationgauche(a->fg);
return rotationdroite(a);
}
parbre equilibrerAVL(parbre a){
if(a==NULL){
return a;
}
if(a->eq>=2){
if(a->fd->eq>=0){
return rotationgauche(a);
}else{
return doublerotationgauche(a);
}}
else if(a->eq<=-2){
if(a->fg->eq<=0){
return rotationdroite(a);
}else{
return doublerotationdroite(a);
}}
return a;
}
void infixeInverse(parbre a, FILE* fichier_temp_s) 
{
    if (a == NULL ) {
        return;
    }
    infixeInverse(a->fd,fichier_temp_s);
    fprintf(fichier_temp_s,"%d;%f;%f;%f;%f\n",a->id,a->min,a->moy,a->max,a->dif);
    infixeInverse(a->fg, fichier_temp_s);
}
void traitement_s(char *fichier) {
  FILE *file = fopen(fichier, "r");
  if (file == NULL) {
    perror("ERREUR : impossible d'ouvrir le fichier csv");
    exit(1);
  }
  int ligne_taille_max = 5000;
  char ligne[ligne_taille_max];
  if (fgets(ligne, ligne_taille_max, file) == NULL) {
    printf("Error: Failed to read the header line\n");
    exit(1);
  }

  trajetf *courant = malloc(sizeof(trajetf));
  int *h = malloc(sizeof(int));
  *h = 0;
  arbre *nouveau = NULL;

  while (fgets(ligne, ligne_taille_max, file) != NULL) {
    sscanf(ligne, "%d;%f;%f;%f;%f", &courant->id,&courant->min,&courant->moy, &courant->max, &courant->dif);
    nouveau = insertionAVL(nouveau, courant, h);
    nouveau = equilibrerAVL(nouveau);
  }
  fclose(file);
  FILE *fichier_temp_s = fopen("temp/data_s.txt", "w");
  if (fichier_temp_s == NULL) {
    perror("ERREUR : impossible d'ouvrir le fichier temp_s");
    exit(1);
  }
  infixeInverse(nouveau,fichier_temp_s);
  fclose(fichier_temp_s);
}
int main(int argc, char *argv[]) {
char *chemin_csv = argv[1];
traitement_s(chemin_csv);
return 0;
}
