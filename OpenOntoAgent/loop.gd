extends Node

var current_tick: int = 0
var social_practices = []

func load_social_practices(all_scenes:=false):
    # Description of social practices
    # Describe roles (character agnostic)
    # It can change the world and characters
    
    pass


func load_word(all_scenes:=false):
    # Initial state of the world
    pass


func load_character():
    # A new character spawns in the world
    pass


func unload_character():
    # A characters leaves the world
    pass


func get_actions(social_practice):
    var actions = []
    for action in social_practice:
        actions.append(action)
    return actions


func tick():
    var actions = []
    for social_practice in social_practices:
        actions.append_array(get_actions(social_practice))
    
    
    
    current_tick += 1
