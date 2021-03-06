(** A module that initiates and handles combat, given a list of characters.*)

(** [move_cd] is an entry in the cooldown list. It has the [move] on cooldown,
    and the number of [turns left] to get off cooldown. *)
type move_cd = 
  {move: Character.move;
   turns_left: int;}

(** type [cd_lst] contains a list of moves of characters that are on cooldown.
    It includes the number of turns left until it is off cooldown. If 
    a move goes from on cooldown to off cooldown, then it should be removed
    from the cd list *)
type cd_lst = move_cd list

(** [type item] represents an item from the [Adventure] module *)
type item = Adventure.item

(**[type c] represents one character on a team.
   Must include Character.c in its representation.*)
type c =
  {
    char_c: Character.c;
    char_name: string;
    char_moves: Character.move list;
    atk: int;
    level: int;
    mutable cur_hp: int;
    mutable buffs : unit list; 
    mutable active: bool;
    mutable cooldown: cd_lst;
  }

(** [team] represents a team of characters.*)
type team = c list

(** [type t] represents the current state of combat. Should include a list of 
    team1 and and team2. Should include a field containing a variant of
     whose turn it is. Includes the winner of the game, '1' for team 1, 
    '2' for team 2, or '0' if no winner yet *)
type t ={
  team1: team;
  team2: team;
  mutable winner: int;
  mutable items: item list
}

exception Winner of int

(** [move_select] distinguishes between a valid move that the user can enter
    , or if an input that does not lead to a valid move*)
type move_select =
  | Valid_m of Character.move
  | Invalid_m

(** [target_select] distinguishes between a valid target that the user can 
    enter, and an input that does not lead to a valid move*)
type target_select = 
  | Valid_tar of c
  | Invalid_tar

(** [item_select] distinguishes between a valid item that the user can use,
    and an input that does not lead to a valid item*)
type item_select = 
  | ValidItem of item
  | InvalidItem

(** [dmg_variation] is the variation % that all damage/healing is subjected to.
    Example: if dmg_variation = 5, then a damage of 100 can be randomly 
    increased to 105 or decreased to 95, maximum *)
val dmg_variation : int

(** [vary k percent] returns a value that deviates from [k] 
    by at most +- [percent]%.
    Requires: 0 <= percent <= 100*)
val vary : float -> int -> float

(** [proc k] is a random bool generator. Returns true with a probability
    of k/100.
    Requires: 0 <= k <= 100 *)
val proc: int -> bool

(** [do_dmg c dmg] subtracts exactly [dmg] to character [c]'s health.
    Does not take into account  variation / buffs, etc. *)
val do_dmg: c -> int -> unit

(** [do_heal c heal] adds exactly [heal] to character [c] health. *)
val do_heal: c -> int -> unit

(** [is_active c] returns true if a character's hp is above 0. *)
val is_active: c -> bool

(** [get_active team] returns [team] with only the active characters *)
val get_active: team -> team


(** [target_input team input] checks if [input] is a valid target in [team].
    If it is, return [Valid_tar target], where [target] is the target chosen.
    Else, return [Invalid_tar]
    Requires: team must be an active_team, meaning no one is dead 
*)
val target_input : team -> string -> target_select

(** [is_team_dead act_team] checks if [act_team] is all dead.
    Requires: [act_team] must be a team type that passed through the get_active
    function *)
val is_team_dead: team -> bool

(** [check_winner act_team inte] raises [Winner inte] exception if act_team 
    is dead.  
    requires: [team] is an active team*)
val check_winner: team -> int -> unit

(** [use_item team items t] allows the user to select one item from [items] 
    and use it on one character on [team]. It will also change[t.items] to
    reflect the consumption of the selected item. *)
val use_item: team -> item list -> t ->  unit

(** [is_move input move] checks if [input] matches the name of [move], 
    it disregards capitalization  *)
val is_move : string -> Character.move -> bool

(** [move_input move_lst input] checks if [input] is a valid move of [char_c].
    Returns: [Valid_m move] for a valid selection, where [move] is the 
    move selected. Else, it returns [Invalid_m].*)
val move_input: Character.move list -> string -> move_select 

(** [get_team n t] will return a tuple of [(current_team, opposing team)]. 
    [current_team] is this team's turn to attack. 
    [opposing team] is the team being attacked.
    Returns (team1, team2) when n = 1,
    Returns (team2, team1) when n = 2 *)
val get_team: int -> t -> team * team

(** [init clst1 clst2 items] initializes a game state [t] with 
    [clist1] as team1, and [clist2] as team2, with [items] loaded *)
val init: (Character.c * int) list -> (Character.c * int) list -> 
  Adventure.item list -> t

(** [start clst1 clst2 items] initializes a game state t using
    [init clist1 clist2 items], and then carries out the combat until a team 
    wins. It will raises an exception for who wins combat. 
    Raises [Winner 1] for team 1 win, Raises [Winner 2] for team 2 win. *)
val start: (Character.c * int) list -> (Character.c * int) list -> 
  Adventure.item list -> unit

(** [mult_start t] initiates multiplayer mode from state [t]. 
    It will allow 2 users to select their 
    team from a random list, and then carries out combat until someone wins.
    Prints out a victory message for the winning team*)
val mult_start: Character.t -> unit

(** [load_char (char, lvl)] loads [char] from Character into a [c] type record
    with level [lvl]*)
val load_char: Character.c * int -> c 

(** [is_on_cd cd] returns true if [cd] is on cd, which means its 
    "turns_left" field above 0. *)
val is_on_cd: move_cd -> bool

(** [add_cd move cd_lst] adds [move] to the cooldown list [cd_lst], with 
    the move's given cooldown*)
val add_cd: Character.move -> cd_lst -> cd_lst

(** [update_cd cd] updates the cooldown entry by decreasing 1 to
    its cooldown *)
val update_cd: move_cd -> move_cd

(** [update_cd_lst cd_lst] updates the cooldown list using [update_cd]. 
    If a move's cooldown reaches 0, then it is removed from the list.  *)
val update_cd_lst: cd_lst -> cd_lst

(** [add_cd_to_char c move] returns a cd_lst of character [c] with [move] 
    on cooldown*)
val add_cd_to_char:  c -> Character.move -> move_cd list

(** [move_on_cd cd_lst move] returns true if [move] is on cooldown, based off
    [cd_lst] *)
val move_on_cd: move_cd list -> Character.move -> bool

(** [moves_off_cd move_lst cd_lst] returns a list of all moves from [move_lst] 
    that are off_cooldown in [cd_lst] *)
val moves_off_cd: Character.move list -> move_cd list -> Character.move list

(** [char_moves_off_cd c] returns a list of all moves that [c] has that 
    are off_cd *)
val char_moves_off_cd: c -> Character.move list

(** [update_cd_team team] updates all character's cooldowns on [team] *)
val update_cd_team: team -> unit

(** [set_teamlvl team lvl] returns a list of (Character.c, level) pair list
    with level [lvl] *)
val set_teamlvl: Character.c list -> int -> (Character.c * int) list
(* Sp combat functions *)

(** [start_sing clst1 clst2 items] is similar to [start], 
    but clst2 will be controlled
    by the computer, and [items] are loaded in.*)
val start_sing: (Character.c * int) list -> (Character.c * int) list -> 
  Adventure.item list -> int * item list

(** [rand_in_lst lst] returns a random element in lst *)
val rand_in_lst : 'a list -> 'a

(** [start_t_sing t] executes turns for the single player mode *)
val start_t_sing: t -> unit 

(**[smartness_of_c char] is the smartness of the character [char]*)
val smartness_of_c: c -> int 

(** [calc_dmg move atk target] is the damage done by [move] with [atk] to 
    [target]. Takes into account effectiveness *)
val calc_dmg: Character.move -> int -> c -> float 
