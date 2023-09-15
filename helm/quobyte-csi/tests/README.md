# Run unit tests 

To run Helm unit tests a helm plugin is needed:

```
helm plugin install https://github.com/quintush/helm-unittest 
```

* Run `helm unittest -3 .` to run tests
  * Verify that failure is due to new changes that were added to the template files.
