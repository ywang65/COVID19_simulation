# COVID19 simulation
## Model
### Hypothesis
![Outlines](/photo/outline.png)
- The number of strangers (e.g. grocery workers) a person will meet in a single day is a constant
- Social connections will be divided into 3 parts: family, close relationship (such as friends) and strangers. The possibility for one to meet with those that in three groups is different.\
### Parameter used as default
![Pt_outlines](/photo/pt_outline.png)
- A infected person will spread the virus from the 2nd day s/he got infected
- Infected people will have symptoms from the 4th day, and will either be isolated at hospital or at home
- If the symptoms are mild, s/he will recover at 15th day
- If the symptoms are severe, s/he will either recover at 22nd day or die
- The fatality rate is 4%
- The possibility that COVID-19 will cause severe illness is 20%


## Simulation results using 1000 families (~3000 people)
![With social distancing](/photo/no_social_distancing.png)
![Without social distancing](/photo/social_distancing.png)

## Things haven't been considered for generating the plots above but you can change the default parameters when using the functions:
1. Different age will have different fatality/infection rate
2. Medical sources limitation. When hospitalized people exceed certain number, the medcial resources (such as ventilators) will not be enough for everyone. And the fatality rate will be increased.
3. Essential workers. Each individual will be treat equally regarding the social connections. Some essential workers, such as grocery store workers and doctors, will have to meet more strangers than ordinary people.
4. Heterogeneity among people. It may take more or less days for one individual to recover from the COVID-19. And this may also depend on one's health condition.\
...
