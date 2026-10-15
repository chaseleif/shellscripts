#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define INFODIR "/sys/class/power_supply/BAT0"

#define errorquit(msg) \
do { \
    perror(msg); \
    return EXIT_FAILURE; \
}while(0);

int main(int argc,char **argv) {
  int full, now, microamperehours;
  char status[16];

  FILE *infile = fopen(INFODIR "/charge_full", "r");
  if (!infile) errorquit(INFODIR "/charge_full");
  fscanf(infile, "%d", &full);
  fclose(infile);
  infile = fopen(INFODIR "/charge_now", "r");
  if (!infile) errorquit(INFODIR "/charge_now");
  fscanf(infile, "%d", &now);
  fclose(infile);
  infile = fopen(INFODIR "/current_now", "r");
  if (!infile) errorquit(INFODIR "/current_now");
  fscanf(infile, "%d", &microamperehours);
  fclose(infile);
  infile = fopen(INFODIR "/status", "r");
  if (!infile) errorquit(INFODIR "/status")
  fscanf(infile, "%15[^\n]s", status);
  fclose(infile);

  fprintf(stdout, "Battery %.1f%%", 100.0f * now / full);
  if (!strcmp(status, "Not charging"))
    fprintf(stdout, "\n");
  else if (!strcmp(status, "Charging"))
    fprintf(stdout, ", %.1f minutes until charged\n",
                    60.0*(full-now)/microamperehours);
  else
    fprintf(stdout, ", %.1f minutes remaining\n",
                    60.0*now/microamperehours);
  return EXIT_SUCCESS;
}
