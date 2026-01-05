const CONFIG = {
  // General
  name: "Cross",
  imageBackground: true,
  openInNewTab: true,
  twelveHourFormat: false,

  // Greetings
  greetingMorning: "Good morning,",
  greetingAfternoon: "Good afternoon,",
  greetingEvening: "Good evening,",
  greetingNight: "Good evening, ",

  // Layout
  bentoLayout: "buttons", // 'bento', 'lists', 'buttons'

  // Weather
  weatherKey: "b5bcd0d984f44960cc9d542dc85eb324",
  weatherIcons: "OneDark", // 'Onedark', 'Nord', 'Dark', 'White'
  weatherUnit: "C", // 'F', 'C'
  language: "en", // More languages in https://openweathermap.org/current#multi

  trackLocation: false, // If false or an error occurs, the app will use the lat/lon below
  defaultLatitude: "28.363800",
  defaultLongitude: "75.600998",

  // Autochange
  autoChangeTheme: false,

  // Autochange by OS
  changeThemeByOS: true,

  // Autochange by hour options (24hrs format, string must be in: hh:mm)
  changeThemeByHour: false,
  hourDarkThemeActive: "18:30",
  hourDarkThemeInactive: "07:00",

  firstButtonsContainer: [
    {
      id: "1",
      name: "Github",
      icon: "github",
      link: "https://github.com/",
    },
    {
      id: "2",
      name: "Mail",
      icon: "mail",
      link: "https://mail.google.com/mail/u/2/#inbox",
    },
    {
      id: "3",
      name: "Nalanda",
      icon: "book",
      link: "https://nalanda-aws.bits-pilani.ac.in/",
    },
    {
      id: "4",
      name: "Clasroom",
      icon: "clipboard",
      link: "https://classroom.google.com/u/1/",
    },
    {
      id: "5",
      name: "Reddit",
      icon: "gem",
      link: "https://reddit.com",
    },
    {
      id: "6",
      name: "Youtube",
      icon: "youtube",
      link: "https://youtube.com/",
    },
  ],

  secondButtonsContainer: [
    {
      id: "1",
      name: "Whatsapp",
      icon: "message-circle",
      link: "https://web.whatsapp.com/",
    },
    {
      id: "2",
      name: "Physics Stack Exchange",
      icon: "atom",
      link: "https://physics.stackexchange.com",
    },
    {
      id: "3",
      name: "MonekeyType",
      icon: "keyboard",
      link: "https://monkeytype.com/",
    },
    {
      id: "4",
      name: "Amazon",
      icon: "shopping-bag",
      link: "https://amazon.com/",
    },
    {
      id: "5",
      name: "ChatGPT",
      icon: "bot",
      link: "https://chat.openai.com/",
    },
    {
      id: "6",
      name: "Ookla",
      icon: "gauge",
      link: "https://www.speedtest.net/",
    },
  ],

  // First Links Container
  firstlistsContainer: [
    {
      icon: "music",
      id: "1",
      links: [
        {
          name: "Inspirational",
          link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
        },
        {
          name: "Classic",
          link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
        },
        {
          name: "Oldies",
          link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
        },
        {
          name: "Rock",
          link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
        },
      ],
    },
    {
      icon: "coffee",
      id: "2",
      links: [
        {
          name: "Linkedin",
          link: "https://www.linkedin.com",
        },
        {
          name: "Dribbble",
          link: "https://www.dribbble.com",
        },
        {
          name: "Trello",
          link: "https://www.trello.com",
        },
        {
          name: "Slack",
          link: "https://www.slack.com",
        },
      ],
    },
  ],

  // Second Links Container
  secondListsContainer: [
    {
      icon: "binary",
      id: "1",
      links: [
        {
          name: "Spotify",
          link: "https://www.spotify.com",
        },
        {
          name: "Reddit",
          link: "https://www.reddit.com",
        },
        {
          name: "Hashnode",
          link: "https://www.hashnode.com",
        },
        {
          name: "Pocket",
          link: "https://www.pocket.com",
        },
      ],
    },
    {
      icon: "github",
      id: "2",
      links: [
        {
          name: "Front",
          link: "https://www.reddit.com/r/Frontend/",
        },
        {
          name: "Rust",
          link: "https://www.reddit.com/r/rust/",
        },
        {
          name: "Go",
          link: "https://www.reddit.com/r/golang/",
        },
        {
          name: "Repos",
          link: "https://github.com/migueravila",
        },
      ],
    },
  ],
};
