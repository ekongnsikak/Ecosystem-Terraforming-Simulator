;; Resource Allocation Contract

(define-map project-resources uint {
  water: uint,
  minerals: uint,
  organic-matter: uint,
  energy: uint
})

(define-public (allocate-resources (project-id uint) (water uint) (minerals uint) (organic-matter uint) (energy uint))
  (let
    ((current-resources (default-to { water: u0, minerals: u0, organic-matter: u0, energy: u0 }
                                    (map-get? project-resources project-id))))
    (ok (map-set project-resources project-id
      {
        water: (+ (get water current-resources) water),
        minerals: (+ (get minerals current-resources) minerals),
        organic-matter: (+ (get organic-matter current-resources) organic-matter),
        energy: (+ (get energy current-resources) energy)
      }))
  )
)

(define-public (use-resources (project-id uint) (water uint) (minerals uint) (organic-matter uint) (energy uint))
  (let
    ((current-resources (unwrap! (map-get? project-resources project-id) (err u404))))
    (asserts! (and
      (>= (get water current-resources) water)
      (>= (get minerals current-resources) minerals)
      (>= (get organic-matter current-resources) organic-matter)
      (>= (get energy current-resources) energy)
    ) (err u400))
    (ok (map-set project-resources project-id
      {
        water: (- (get water current-resources) water),
        minerals: (- (get minerals current-resources) minerals),
        organic-matter: (- (get organic-matter current-resources) organic-matter),
        energy: (- (get energy current-resources) energy)
      }))
  )
)

(define-read-only (get-project-resources (project-id uint))
  (map-get? project-resources project-id)
)

