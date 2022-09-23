Let $f(x) = \frac{x}{\ln(x)}$. Then $f(e) = e$ and also $f'(x) = \frac{\ln(x) - 1}{\ln(x)^2}$.

Since $\ln(e) = 1$, $\ln(x) > 1$, so $\ln(x) - 1 > 0$. Divide by $\ln(x)^2$ to get $\frac{\ln(x) - 1}{\ln(x)^2} > 0$ i.e. $f'(x) > 0$. Since $x > e$, the function $f$ is monotone increasing after $e$.

Now if $f(e) = e$, then $f(e+\delta) > e$ for $\delta > 0$, and since $\exists \delta, e+\delta = \pi$, then $f(\pi) > e$ i.e. $\frac{\pi}{\ln(\pi)} > e$.

So $\pi > e \ln(\pi)$ gives $e^\pi > e^{e \ln(\pi)}$ which is $e^\pi > \pi^e$.