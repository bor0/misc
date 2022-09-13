# Task description

There are 5 people in front of you, you know two of them are spies, but you don’t know which. If you have two distinct selections of 4 of those 5 people, selections A (e.g. persons 1, 2, 3, 4) and B (e.g. persons 2, 3, 4, 5), then:

1. What is the probability that selection A has 2 spies?
2. If you have to choose between A and B, and pick one of them, what is the probability you made the right choice, where the right choice is most likely to have 2 spies?

# Solution

Here's my solution in proof-style fashion. This might look neater in the language of probability but anyway here goes.

There are 5 possible sets. Let:

$$S = \{
\{1, 2, 3, 4\}, \\
\{1, 2, 3, 5\}, \\
\{1, 2, 4, 5\}, \\
\{1, 3, 4, 5\}, \\
\{2, 3, 4, 5\}
\}$$

We are interested in $S' = (A,B) \in S \times S \land A \neq B$, particularly $A$. There will be total of 20 sets.

There are 10 combinations of spies:

$$\{ \{1,2\}, \{1,3\}, \{1,4\}, \{1,5\}, \{2,3\}, \{2,4\}, \{2,5\}, \{3,4\}, \{3,5\}, \{4,5\} \}$$

WLOG we pick $\{1, 2\}$. It can be easily seen that there are 12 $A$'s s.t. $\{1,2\} \subset A \land \forall B, (A, B) = S'$. So $\frac{12}{20}$.

For task 2, since $S'$ is symmetric, we have that the probability is 50% between A and B. 

