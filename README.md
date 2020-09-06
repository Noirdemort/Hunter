# Hunter

Access Level: PRIVAC


This project tries to implement ![System Design](/sysdes.png).


The whole idea is to treat data as passive entity while functions as an active entity.
Processor recieve calling from interface, draws data from translator and uses state to perform proper functions.


Ideally,

Model: This should contain only model and related characterstics.

Processor: This contains all functions related to processing of the business logic and related requirements.

State: This should contain state, ideally at a global level.

Data Storage: Component storing data

Data Translator: Takes data from data storage and casts it to Model.

User Interface: Most volatile component, calls processor for functions.

Auth Model (Optional): This can be used with defined policies to authorize a User.
	Self-requirement: case where user can edit her own created instances only.
	This part is quite nuanced and abstract, so take any liberty if required.

NOTE: Functions shouldn't have side-effects, even state should be passed as a parameter.
Like a global object shouldn't be called implicitly but like passed via parameter.

Basically, State + Processor + Model -> Core Business Value

## Feel free to tell me how this design is totally awful and a work of satan and how this opposes all good in the world, by creating a pull request or creating an issue.
## Also, it would be helpful if you could suggest improvements too.