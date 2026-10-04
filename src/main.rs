use escpos::printer::Printer;
use escpos::utils::*;
use escpos::{driver::*, errors::Result};

fn main() -> Result<()> {
    // check https://docs.rs/escpos/latest/escpos/driver/index.html for the details
    let driver = UsbDriver::open(0x04b8, 0x0e28, None, None)?;
    Printer::new(driver, Protocol::default(), None)
        .init()?
        .smoothing(true)?
        .bold(true)?
        .underline(UnderlineMode::None)?
        .justify(JustifyMode::CENTER)?
        .reverse(true)?
        .size(3, 3)?
        .writeln(" Lista p/ Mala ")?
        .feed()?
        .justify(JustifyMode::LEFT)?
        .size(2, 2)?
        .reverse(false)?
        .bold(true)?
        .writeln("Roupa")?
        .bold(false)?
        .print_cut()?;


    Ok(())
}
