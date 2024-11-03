use clipboard_win::{formats, set_clipboard};
use rand::Rng;
use std::env;
use std::io;
use std::process::Command;

fn main() -> Result<(), Box<dyn std::error::Error>> {
  let mut exclude_chars = String::new();
  let mut passwd_length = 48;
  let mut args = env::args().skip(1);

  while let Some(arg) = args.next() {
    match arg.as_str() {
      "-e" => {
        if let Some(exclude) = args.next() {
          exclude_chars = exclude;
        }
      }
      "-l" => {
        if let Some(length) = args.next() {
          if let Ok(len) = length.parse::<usize>() {
            passwd_length = len;
          } else {
            eprintln!("Invalid length provided for -l argument");
            return Err("Invalid length argument".into());
          }
        }
      }
      "upgrade" => {
        Command::new("powershell")
            .arg("irm https://raw.githubusercontent.com/Alixxx-please/passwd/master/install.ps1 | iex")
            .output()
            .expect("Failed to execute upgrade command");
        return Ok(());
      }
      "uninstall" => {
        Command::new("powershell")
            .arg("irm https://raw.githubusercontent.com/Alixxx-please/passwd/master/uninstall.ps1 | iex")
            .output()
            .expect("Failed to execute uninstall command");
        return Ok(());
      }
      _ => {}
    }
  }

  let password = generate_password(passwd_length, &exclude_chars)?;
  println!("{}", password);
  set_clipboard(formats::Unicode, password).expect("To set clipboard");
  
  let mut input = String::new();
  io::stdin()
      .read_line(&mut input)
      .expect("Error when reading input");

  Ok(())
}

fn generate_password(length: usize, exclude: &str) -> Result<String, &'static str> {
  let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  let symbols = "!@#$%^&*()_+-=[]{}|;:,.<>?/\\'`~°£¤§ ";
  let digits = "0123456789";
  let all = format!("{}{}{}", chars, symbols, digits);

  let filtered_all: Vec<char> = if exclude.is_empty() {
    all.chars().collect()
  } else {
    all.chars().filter(|c| !exclude.contains(*c)).collect()
  };

  if filtered_all.is_empty() {
    return Err("Empty character list after exclusion.");
  }

  let mut rng = rand::thread_rng();
  let password: String = (0..length)
      .map(|_| {
        let idx = rng.gen_range(0..filtered_all.len());
        filtered_all[idx]
      })
      .collect();

  Ok(password)
}