#include<stdio.h>
#include<stdlib.h>
#include"avl.h"

typedef struct arbre
{
    int elmt;
    struct arbre *fg;
    struct arbre *fd;
    int equilibre;
} arbre;
typedef struct arbre *parbre;
parbre creerarbre(int r)
{
    arbre *nouveau = malloc(sizeof(arbre));
    if (nouveau == NULL)
    {
        printf("Erreur d'allocation.\n");
        exit(1);
    }
    nouveau->elmt = r;
    nouveau->fg = NULL;
    nouveau->fd = NULL;
    nouveau->equilibre=0;
    return nouveau;
}
parbre recherche(parbre a, int e)
{
    if (a == NULL)
    {
        return NULL;
    }
    else if (a->elmt == e)
    {
        return a;
    }
    else if (a->elmt > e)
    {
        return recherche(a->fg, e);
    }
    else if (a->elmt < e)
    {
        return recherche(a->fd, e);
    }
}
parbre insertionAVL(parbre a, int e, int *h)
{
if(a==NULL){
*h=1;
return creerarbre(e);
}
else if(e < a->elmt){
a->fg=insertionAVL(a->fg,e,h);
*h=-*h;
}
else if(e > a->elmt){
a->fd=insertionAVL(a->fd,e,h);
}
else{
*h=0;
return a;
}
if(*h !=0){
a->equilibre=a->equilibre+*h;
if(a->equilibre==0){
*h=0;
}else{
*h=1;
}}
return a;
}
parbre suppressionAVL(parbre a, int e, int *h){
parbre tmp=malloc(sizeof(arbre));
if(a==NULL){
*h=1;
return a;
}else if (e > a->elmt){
a->fd=suppressionAVL(a->fd,e,h);
}else if (e < a->elmt){
a->fg=suppressionAVL(a->fg,e,h);
}else if (a->fd!=NULL){
a->fg=suppMinAVL(a->fd,h,*a->elmt);
}else{
tmp=a;
a=a->fg;
free(tmp);
*h=-1;
}
if(*h!=0){
a->equilibre=a->equilibre+*h;
if(a->equilibre==0){
*h=0;
}else{
*h=1;
}
}
return a;
}
parbre suppMinAVL(parbre a, int *h, int *pe){
parbre tmp=malloc(sizeof(arbre));
if(a->fg==NULL){
*pe=a->elmt;
*h=-1;
tmp=a;
a=a->fd;
free(tmp);
return a;
}else{
a->fg=suppMinAVL(a->fg,h,pe);
*h=-*h;
}
if(*h!=0){
a->equilibre=a->equilibre+*h;
if(a->equilibre==0){
*h=-1;
}else{
*h=0;
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
eq_a=a->equilibre;
eq_p=pivot->equilibre;
a->equilibre=eq_a-max(eq_p,0)-1;
pivot->equilibre=min(eq_a-2,eq_a+eq_p-2,eq_p-1);
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
eq_a=a->equilibre;
eq_p=pivot->equilibre;
a->equilibre=eq_a-min(eq_p,0)+1;
pivot->equilibre=max(eq_a+2,eq_a+eq_p+2,eq_p+1);
a=pivot;
return a;
}
parbre doublerotationgauche(parbre a){
a->fd=rotationdroite(a->fd);
return rotationgauche(a);
}
parbre doublerotationdroite(parbre a){
a->fd=rotationgauche(a->fd);
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
