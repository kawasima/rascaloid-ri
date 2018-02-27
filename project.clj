(defproject rascaloid-ri "0.1.0-SNAPSHOT"
  :dependencies [[org.clojure/clojure "1.9.0"]
                 [net.unit8.darzana/darzana "1.0.0-SNAPSHOT"]]
  :main darzana.main
  :profiles {:docker {:local-repo "lib"}})
