(def *input*
  (let [l @[]
        f (file/open "input")]
    (loop [v :in (file/lines f)]
      (array/push l (string/trimr v)))
    (file/close f)
    l))

(defn unfuck [s]
  (filter
   (fn [s] (not (= s "")))
   (string/split " " s)))

(def *ops*
  (map
   (fn [it] (if (= it "*") * +))
   (unfuck (array/peek *input*))))

(defn solve1 []
  (let [l (map
           (fn [s] (map scan-number (unfuck s)))
           *input*)
        ns (array/slice l 0 (- (length l) 1))]
    (reduce
      (fn [a b] (+ a (apply (get *ops* b) (map (fn [l] (get l b)) ns))))
      0
      (range 0 (length (get l 0))))))

# place -> [[n ...] place]
(defn getn [p]
  (let [wl (- (length *input*) 1)
        vs (array/new 0)]
    (var p* p)
    (while true
      (var nsp 0)
      (loop [i :range (0 wl)]
        (let [c (- (or (get (get *input* i) p*) 20) 48)]
          (if (and (>= c 0) (<= c 9))
            (put vs (- p* p) (+ (* (or (get vs (- p* p)) 0) 10) c))
            (set nsp (+ nsp 1)))))
      (set p* (+ p* 1))
      (when (>= nsp wl)
        (break)))
    [vs p*]))

(defn solve2 []
  (let [max (length (get *input* 0))]
    (var i 0)
    (var p 0)
    (var sum 0)
    (while (< p max)
      (def [vs p*] (getn p))
      (set p p*)
      (set sum (+ sum (apply (get *ops* i) vs)))
      (set i (+ i 1)))
    sum))

(print "p1: " (solve1))
(print "p2: " (solve2))
