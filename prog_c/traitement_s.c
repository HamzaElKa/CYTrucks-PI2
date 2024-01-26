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
