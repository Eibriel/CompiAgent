extends Node


class greet:
    func active(parameters):
        var X = parameters[0]
        var Y = parameters[1]
        
        return true
    
    func execute(parameters):
        pass


# preconditions
# actions


"""

action move(A, X, Y)
    preconditions
        A.at!X
    postconditions
        add A.at!Y


process.greet.X(agent).Y(agent)
    action "Greet"
        preconditions
            // They must be co-located
            X.in!L and Y.in!L
        postconditions
            text "[X] says ’Hi’ to [Y obj]"
end

"""
