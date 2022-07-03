# extends Node

"""

concept.event.ingest.agent.sem.human
concept.event.ingest.agent.sem.animal
concept.event.ingest.agent.relaxable-to.social-object
concept.event.ingest.theme.sem.food
concept.event.ingest.theme.sem.beverage
concept.event.ingest.theme.sem.ingestible-medication
concept.event.ingest.theme.relaxable-to.animal
concept.event.ingest.theme.relaxable-to.plant
concept.event.ingest.theme.not.human

"""


var concepts = {
    "INGEST": {
        "PROB": 0.7,
        "IS-A": "EVENT",
        "AGENT": {
            "SEM": ["HUMAN", "ANIMAL"],
            "RELAXABLE-TO": ["SOCIAL-OBJECT"]
        },
        "THEME": {
            "SEM": ["FOOD", "BEVERAGE", "INGESTIBLE-MEDICATION"],
            "RELAXABLE-TO": ["ANIMAL", "PLANT"],
            "NOT": ["HUMAN"]
        }
    },

    "WATCH-MEDIA": {
        "PROB": 0.7,
        "IS-A": "EVENT",
        "AGENT": {
            "SEM": ["HUMAN"],
            "RELAXABLE-TO": ["SOCIAL-OBJECT"]
        },
        "THEME": {
            "SEM": ["FILM", "TV-SHOW"]
        }
    },

    "PET": {
        "PROB": 0.7,
        "IS-A": "EVENT",
        "AGENT": {
            "SEM": ["HUMAN"],
        },
        "THEME": {
            "SEM": ["ANIMAL"],
        }
    },

    "NUT-FOODSTUFF": {
        "PROB": 0.6,
        "IS-A": "FOOD"
    },

    "FOOD": {
        "PROB": 0.7,
        "IS-A": "SOLID"
    },
    
    "SOLID": {
        "PROB": 0.3,
        "IS-A": "THING"
    },

    "SQUIRREL": {
        "PROB": 0.6,
        "IS-A": "ANIMAL"
    },

    "ANIMAL": {
        "PROB": 0.7,
        "IS-A": "ORGANISM"
    },
    
    "ORGANISM": {
        "PROB": 0.3,
        "IS-A": "THING"
    },
    
    "I": {
        "PROB": 0.8,
        "IS-A": "HUMAN"
    },
    
    "HUMAN": {
        "PROB": 0.6,
        "IS-A": "ANIMAL"
    },
    
    "WATER": {
        "PROB": 0.7,
        "IS-A": "BEVERAGE"
    },
    
    "BEVERAGE": {
        "PROB": 0.5,
        "IS-A": "THING"
    },
    
    "FILM": {
        "PROB": 0.6,
        "IS-A": "THING"
    },
    
    "EVENT": {
        "PROB": 0.2,
        "IS-A": "ROOT",
    },
    
    "THING": {
        "PROB": 0.2,
        "IS-A": "ROOT",
    },
    
    "ROOT": {
        "PROB": 0.01,
    }
}
