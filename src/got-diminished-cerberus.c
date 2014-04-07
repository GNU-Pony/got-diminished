/**
 * got-diminished – Extension for gates-of-tartaros to minimise memory usage after logging in
 * 
 * Copyright © 2013, 2014  Mattias Andrée (maandree@member.fsf.org)
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
#include <sys/wait.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>


int main(int argc, char** argv)
{
  pid_t pid = vfork();
  if (pid == -1)
    {
      perror("vfork");
      return 1;
    }
  
  if (pid)
    {
      waitpid(pid, &pid, 0);
      {
	int n = 0, i;
	char* stty = *(argv + 2);
	char* stty_cmd;
	
	while (*(stty + n++))
	  ;
	
	stty_cmd = malloc(5 + n);
	for (i = 0; i < 5; i++)
	  *(stty_cmd + i) = *("stty " + i);
	stty_cmd += 5;
	for (i = 0; i < n; i++)
	  *(stty_cmd + i) = *(stty + i);
	stty_cmd -= 5;
	
	system(stty_cmd);
	free(stty_cmd);
      }
    }
  else
    execlp("setsid", "setsid", "-c", "cerberus", "--", *(argv + 1), NULL);
  
  return 0;
}

