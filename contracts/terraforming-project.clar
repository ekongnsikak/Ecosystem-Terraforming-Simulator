;; Terraforming Project Contract

(define-data-var project-counter uint u0)

(define-map terraforming-projects uint {
  planet-name: (string-ascii 50),
  project-status: (string-ascii 20),
  current-stage: uint,
  total-stages: uint,
  start-date: uint,
  estimated-completion: uint,
  project-manager: principal
})

(define-public (create-project (planet-name (string-ascii 50)) (total-stages uint) (estimated-completion uint))
  (let
    ((new-id (+ (var-get project-counter) u1)))
    (map-set terraforming-projects new-id {
      planet-name: planet-name,
      project-status: "initiated",
      current-stage: u1,
      total-stages: total-stages,
      start-date: block-height,
      estimated-completion: estimated-completion,
      project-manager: tx-sender
    })
    (var-set project-counter new-id)
    (ok new-id)
  )
)

(define-public (update-project-status (project-id uint) (new-status (string-ascii 20)))
  (let
    ((project (unwrap! (map-get? terraforming-projects project-id) (err u404))))
    (asserts! (is-eq tx-sender (get project-manager project)) (err u403))
    (ok (map-set terraforming-projects project-id
      (merge project { project-status: new-status })))
  )
)

(define-public (advance-project-stage (project-id uint))
  (let
    ((project (unwrap! (map-get? terraforming-projects project-id) (err u404))))
    (asserts! (is-eq tx-sender (get project-manager project)) (err u403))
    (asserts! (< (get current-stage project) (get total-stages project)) (err u400))
    (ok (map-set terraforming-projects project-id
      (merge project { current-stage: (+ (get current-stage project) u1) })))
  )
)

(define-read-only (get-project (project-id uint))
  (map-get? terraforming-projects project-id)
)

(define-read-only (get-project-count)
  (var-get project-counter)
)

