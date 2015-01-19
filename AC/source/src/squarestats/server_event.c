/* server_event.c */

#include <stdlib.h>
#include <stdio.h>
#include "event_json.h"
#include "server_zmq.h"

/* Are we currently in a game? */
int is_in_game = 0;

/* Called when a player kills another (or themselves). */
void on_event_kill(const char* killer, const char* victim, const char* weapon,
                   unsigned int time, int gib, int suicide)
{        
        const char* json = event_kill_json(killer, victim, weapon, time, gib,
                                           suicide);
        
        send_message(json);
        printf("[SquareStats]\n%s\n", json);
        
        free((void*) json);
        json = NULL;
}

/* Called when a new game begins. */
void on_event_game_start(const char* map, const char* mode)
{
        /* The hooks are a little unreliable. Only start a new game if we
         * aren't already in one. */
        if(is_in_game) { return; }
        
        const char* json = event_game_start_json(map, mode);
        
        send_message(json);
        printf("[SquareStats]\n%s\n", json);

        
        free((void*) json);
        json = NULL;
        
        is_in_game = 1;
}

/* Called when the current game ends - either by timing out, or if everyone
 * leaves the server. */
void on_event_game_end()
{
        /* Only output the event if we actully are in a game,
         * this is neccessary due to the hook being called in
         * a loop while there are no players on the server. */
        if(!is_in_game) { return; }
        
        const char* json = event_game_end_json();
        
        send_message((void*) json);
        printf("[SquareStats]\n%s\n", json);        

        free((void*) json);
        json = NULL;
        
        is_in_game = 0;
}
