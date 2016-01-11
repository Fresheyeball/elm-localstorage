# Elm LocalStorage

Simple API into `localStorage` in the browser.

```elm  
storage : LocalStorage Foo
storage =
  { key = "myStorageKey"
  , encode = encodeFooToString
  , decode = decodeFooFromString }

restore : Task String Foo
restore =
  get storage

save : Foo -> Task x ()
save foo =
  set storage foo
```
