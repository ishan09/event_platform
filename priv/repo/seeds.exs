alias EventPlatform.UserManagement.TopicOfInterest
alias EventPlatform.Repo

{:ok, now} = NaiveDateTime.new(~D[1990-01-13], ~T[12:00:00])


topics =
  [
    "Photography",
    "Space",
    "Sports",
    "Car",
    "Bikes",
    "Rock Music",
    "Art & Craft",
    "Mountain Terk",
    "Dance",
    "Personal Finance",
    "Parenting",
    "Video Editing",
    "Video Games",
    "Accounting",
    "Digital Marketing",
    "Web Development",
    "Mobile Apps",
    "Leadership",
    "Food & Beverage",
    "Travel"
  ]
  |> Enum.map(&%{title: &1, inserted_at: now, updated_at: now})

Repo.insert_all(
  TopicOfInterest,
  topics
)
