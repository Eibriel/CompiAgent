# CompiAgent
Ontology first Artificial Intelligence Agent

This repository includes a reference implementation written in Godot (WIP)

Here you can find information about the motivation behind the project ([Medium article](https://medium.com/eibriel/open-virtual-beings-for-the-open-metaverse-e35f7c0c0fc)).

## What is CompiAgent
CompiAgent is a file standard to store, run and share intelligent virtual beings that can run locally.

Includes:
- A conversational user interface using a simplified natural language (in progress)
- An ontology engine to store a simplified model of the concepts that can be found in the world (in progress)
- A fact engine database to store static knowledge about the world (not started)
- A short term / long term memory to store knowledge about the environment (not started)
- A lexicon engine to store mappings between concepts and natural language (not started)

Databases:
- Ontology (concepts)
- Facts (concept instances)
- Lexicon (lexemes)
- Onomasticon (names)

Download datasets from [Kaggle](https://www.kaggle.com/datasets/eibriel/compiagent).

## How to test it?

Can be tested online on the Itch.io page: https://eibriel.itch.io/compi (changes on the databases will not be saved)

## How to contribute?

**Databases content (concepts, instances, etc) must be original, must not be copied from a paper, a book or any other source**

**When contributing to the databases (concepts, instances, etc) you accept that the contribution will be released under the Creative Commons Attribution 4.0 International License**

Download Godot: https://godotengine.org/download

Clone this repo locally

When opening Godot select "Import Project", and find the cloned folder

Once imported you can run it with the "Play" button on the top right corner

Frames are saved on `frames.json` and instances in `instances.json`.

For guidelines on what concepts to add and how to differenciate concepts and instances you can check the [following paper](https://www.researchgate.net/publication/2775702_Ontology_Development_for_Machine_Translation_Ideology_and_Methodology).

---

Eibriel
https://twitter.com/EibrielBot

References:
- [Linguistics for the Age of AI](https://mitpress.mit.edu/books/linguistics-age-ai)
- [Ontology Development for Machine Translation: Ideology and Methodology](https://www.researchgate.net/publication/2775702_Ontology_Development_for_Machine_Translation_Ideology_and_Methodology)
- [Mikrokosmos Ontology](http://web.archive.org/web/19980207201036/http://crl.nmsu.edu/users/mahesh/onto-intro-page.html) (Archived version)
