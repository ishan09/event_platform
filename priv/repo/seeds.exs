alias EventPlatform.UserManagement.{TopicOfInterest, User}
alias EventPlatform.EventManagement.{Event, Invite}

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

users = [
  %{
    first_name: "admin",
    last_name: "user",
    email: "admin@example.com",
    gender: "male",
    role: "admin",
    password: "admin1"
  },
  %{
    first_name: "member1",
    last_name: "user",
    email: "member1@example.com",
    gender: "male",
    role: "member",
    password: "member1"
  },
  %{
    first_name: "member2",
    last_name: "user",
    email: "member2@example.com",
    gender: "male",
    role: "member",
    password: "member2"
  },
  %{
    first_name: "member3",
    last_name: "user",
    email: "member3@example.com",
    gender: "male",
    role: "member",
    password: "member3"
  }
]

users
|> Enum.each(fn user_attrs ->
  %User{}
  |> User.changeset(user_attrs)
  |> Repo.insert()
end)

events = [
  %{
    title: "Event 1",
    description: "Event 1 Description",
    start_time: "2020-12-31 14:00:00",
    end_time: "2020-12-31 16:00:00",
    location: "New Delhi",
    type: "Some Type"
  },
  %{
    title: "Event 2",
    description: "Event 2 Description",
    start_time: "2021-11-30 14:00:00",
    end_time: "2021-11-30 16:00:00",
    location: "New Delhi",
    type: "Some Type"
  },
  %{
    title: "Event 3",
    description: "Event 3 Description",
    start_time: "2021-10-31 14:00:00",
    end_time: "2021-10-31 14:30:00",
    location: "New Delhi",
    type: "Some Type"
  },
  %{
    title: "Event 4",
    description: "Event 4 Description",
    start_time: "2021-12-26 14:00:00",
    end_time: "2021-12-26 15:00:00",
    location: "New Delhi",
    type: "Some Type"
  }
]

events
|> Enum.each(fn event_attrs ->
  %Event{}
  |> Event.changeset(event_attrs)
  |> Repo.insert()
  |> IO.inspect(label: "events--- ")
end)

# Hardcoding invites since, ids are autogenrated in sequence, will not work if ids are uuid
# event 1 == 1 invited, 1 cancelled, 1 accepted
# event 2 ==  1 invited, 0 cancelled, 2 accepted
# event 3 == 2 invited, 0 cancelled, 1 accepted
# event 4 == 0 invited, 1 cancelled, 2 accepted
invites = [
  %{status: 1, event_id: 1, user_id: 2},
  %{status: 2, event_id: 1, user_id: 3},
  %{status: 3, event_id: 1, user_id: 4},
  %{status: 1, event_id: 2, user_id: 2},
  %{status: 3, event_id: 2, user_id: 3},
  %{status: 3, event_id: 2, user_id: 4},
  %{status: 1, event_id: 3, user_id: 2},
  %{status: 1, event_id: 3, user_id: 3},
  %{status: 3, event_id: 3, user_id: 4},
  %{status: 2, event_id: 4, user_id: 2},
  %{status: 3, event_id: 4, user_id: 3},
  %{status: 3, event_id: 4, user_id: 4}
]

invites
|> Enum.each(fn invite_attrs ->
  %Invite{}
  |> Invite.changeset(invite_attrs)
  |> Repo.insert()
  |> IO.inspect(label: "invites--- ")
end)
