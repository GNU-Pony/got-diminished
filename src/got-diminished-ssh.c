/**
 * got-diminished – Extension for gates-of-tartaros to minimise memory usage after logging in
 * 
 * Copyright © 2013  Mattias Andrée (maandree@member.fsf.org)
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#include <stdlib.h>
#include <unistd.h>


int main(int argc, char** argv)
{
  int n = 0, i;
  char* user = *(argv + 1);
  char* command;
  
  while (*(user + n++))
    ;
  
  command = malloc(14 + n);
  for (i = 0; i < 14; i++)
    *(command + i) = *("setsid -c ssh " + i);
  command += 14;
  for (i = 0; i < n; i++)
    *(command + i) = *(user + i);
  command -= 14;
  
  if (system(command))
    sleep(3);
  free(command);
  
  execlp("stty", "stty", *(argv + 2), NULL);
  
  return 0;
}

