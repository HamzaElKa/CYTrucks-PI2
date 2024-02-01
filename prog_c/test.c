#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct trajet {
  int id;
  float distance;
  struct trajet* next;
} trajet;

typedef struct arbre {
  int id;
  float max;
  float min;
  struct arbre* fg;
  struct arbre* fd;
  int eq;
} arbre;

typedef struct arbre* parbre;

typedef struct {
  int id;
  float distance;
} trajet_raw;

typedef struct {
  int id;
  float max;
  float min;
  float moy;
  struct arbre* next;
} trajet_formatted;

parbre creerarbre(trajet_raw* d) {
  arbre* nouveau = malloc(sizeof(arbre));
  if (nouveau == NULL) {
    printf("Erreur d'allocation.\n");
    exit(1);
  }
  nouveau->id = d->id;
  nouveau->max = d->distance;
  nouveau->min = d->distance;
  nouveau->fg = NULL;
  nouveau->fd = NULL;
  nouveau->eq = 0;
  return nouveau;
}

parbre insertionAVL(parbre a, trajet_raw* d, int* h) {
  if (a == NULL) {
    *h = 1;
    return creerarbre(d);
  } else if (d->id < a->id) {
    a->fg = insertionAVL(a->fg, d, h);
    *h = -*h;
  } else if (d->id > a->id) {
    a->fd = insertionAVL(a->fd, d, h);
  } else {
    *h = 0;
    if (d->distance > a->max) {
      a->max = d->distance;
    }
    if (d->distance < a->min) {
      a->min = d->distance;
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

parbre equilibrerAVL(parbre a) {
  if (a->eq >= 2) {
    if (a->fd->eq >= 0) {
      return rotationgauche(a);
    } else {
      return doublerotationgauche(a);
    }
  } else if (a->eq <= -2) {
    if (a->fg->eq <= 0) {
      return rotationdroite(a);
    } else {
      return doublerotationdroite(a);
    }
  }
  return a;
}

void postfixe(parbre a, trajet_formatted** tableau, int* i) {
  if (a == NULL) {
    return;
  }
  postfixe(a->fd, tableau, i);
  postfixe(a->fg, tableau, i);

  // Add the current node's data to the linked list
  trajet_formatted* newNode = malloc(sizeof(trajet_formatted));
  if (newNode == NULL) {
    printf("Error: Memory allocation failed\n");
    exit(EXIT_FAILURE);
  }
  newNode->id = a->id;
  newNode->max = a->max;
  newNode->min = a->min;
  newNode->moy = (a->max - a->min) / 2;
  newNode->next = *tableau;
  *tableau = newNode;
}

void freeLinkedList(trajet_formatted* head) {
  while (head != NULL) {
    trajet_formatted* temp = head;
    head = head->next;
    free(temp);
  }
}

void traitement_s(char* fichier) {
  FILE* file = fopen(fichier, "r");
  if (file == NULL) {
    perror("ERREUR : impossible d'ouvrir le fichier csv");
    exit(1);
  }

  int ligne_taille_max = 1024;
  char ligne[1024];

  // Read and discard the first line (header)
  if (fgets(ligne, ligne_taille_max, file) == NULL) {
    printf("Error: Failed to read the header line\n");
    exit(1);
  }

  trajet_raw courant;
  int h = 0;
  arbre* nouveau = NULL;

  while (fgets(ligne, ligne_taille_max, file) != NULL) {
    printf("Before sscanf: %s\n", ligne);
    if (sscanf(ligne, "%d;%*[^;];%*[^;];%*[^;];%f;%*[^;]", &courant.id, &courant.distance) != 2) {
      printf("Error: sscanf failed\n");
      exit(1);
    }
    printf("After sscanf: %d, %f\n", courant.id, courant.distance);

    nouveau = insertionAVL(nouveau, &courant, &h);
    nouveau = equilibrerAVL(nouveau);
  }

  fclose(file);

  trajet_formatted* tableau = NULL;
  int i = 0;
  postfixe(nouveau, &tableau, &i);
  free(nouveau);

  FILE* fichier_temp_s = fopen("data_s.txt", "w");
  if (fichier_temp_s == NULL) {
    perror("ERREUR : impossible d'ouvrir le fichier temp_s");
    exit(EXIT_FAILURE);
  }

  // Print the linked list to the file
  while (tableau != NULL) {
    fprintf(fichier_temp_s, "%d;%f;%f;%f\n", tableau->id, tableau->min, tableau->max, tableau->moy);
    trajet_formatted* temp = tableau;
    tableau = tableau->next;
    free(temp);
  }

  fclose(fichier_temp_s);
}

int main() {
  traitement_s("data_2.csv");
  return 0;
}

