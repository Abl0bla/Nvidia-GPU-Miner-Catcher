# GpuShield-Monitor

A lightweight, stealthy diagnostic tool designed to track GPU resource spikes and identify hidden background processes (such as miners) on Windows systems.

## Prerequisites
* **OS**: Windows 10 or 11
* **Hardware**: NVIDIA GPU (This script strictly relies on the `nvidia-smi` tool included with NVIDIA drivers to read power, temperature, and clock data).

## Project Overview
This project was developed to investigate anomalous GPU behavior, such as sudden fan speed increases or clock spikes while the system is supposedly idle. By correlating raw hardware data from `nvidia-smi` with active system processes, it provides a clear audit trail of what is actually waking up your hardware.

### Key Features
* **Stealth Execution**: Uses a VBScript wrapper to prevent the "PowerShell flash" (command window pop-up), making the monitoring invisible to users and evasive malwares.
* **Process Correlation**: Logs the specific process with the highest CPU usage at the exact moment of the GPU spike.
* **System Mimicry**: File names are designed to blend in with native Windows telemetry and diagnostic services.
* **Environment Agnostic**: Uses Windows environment variables (e.g., `%PUBLIC%`) to ensure compatibility across different user profiles without hardcoded paths.

## Technical Implementation (Stealth Architecture)

### 1. DiagTrackData.ps1 (The Logic)
This PowerShell script acts as the core engine. It queries the NVIDIA driver for utilization, power draw, temperature, and clock speeds, appending them to a hidden log file along with the current top system process.

### 2. WinServiceHost.vbs (The Wrapper)
To avoid detection and user annoyance, this VBScript executes the PowerShell logic in Hidden Mode (0). This ensures that no terminal window ever appears on the taskbar or screen.

## How to Setup

1. Place both `DiagTrackData.ps1` and `WinServiceHost.vbs` in your `C:\Users\Public\Documents\` folder.
2. Open Task Scheduler as Administrator.
3. Create a new task named `Microsoft-Windows-DiskDiagnosticData` (for obfuscation).
4. **Trigger**: Set to "At log on" and "Repeat task every 1 minute" for indefinite duration.
5. **Action**: Start a program.
   * **Program**: `wscript.exe`
   * **Arguments**: `"C:\Users\Public\Documents\WinServiceHost.vbs"`
6. Ensure "**Run with highest privileges**" is checked.

## Usage and Testing Methodologies

### 1. The Idle Miner Test (Recommended)
Many modern cryptominers are programmed to activate only when the user is away to avoid detection. To catch them:
* Restart your PC.
* Do not open any applications or move the mouse. Leave the computer completely idle for 30 minutes to 1 hour.
* Return and check the `WinSelfDiag.log` file in `C:\Users\Public\Documents\`. Look for sudden GPU usage spikes (e.g., jumping to 90-100%) and check the "Owner" column to identify the culprit.

### 2. The Active Background Test
You can also leave the scheduled task running while you use your PC normally. Whether you are gaming, browsing, or running animated wallpapers, the script will silently log the data in the background without impacting your performance.

## Versão em Português (Resumo)

Este é um projeto de monitoramento defensivo para Windows. Ele utiliza scripts integrados para capturar o uso da GPU (exclusivo para placas NVIDIA) e identificar qual processo está causando picos de clock ou consumo.

* **Metodologia de Teste (Ocioso)**: Reinicie o PC e deixe-o parado de 30 a 60 minutos para capturar mineradores que só ativam quando você não está usando a máquina.
* **Metodologia de Teste (Ativo)**: Use o PC normalmente. O script roda em segundo plano sem afetar o desempenho, registrando o impacto de aplicativos do dia a dia.
* **Ofuscação e Invisibilidade**: Os nomes de arquivos mimetizam serviços reais do Windows e o wrapper VBScript elimina o "flash" da janela do terminal.
* **Análise de Dados**: Gera logs em `C:\Users\Public\Documents\WinSelfDiag.log`.

## License
This project was created by Ablobla (Gabriel Oliveira) for diagnostic and security monitoring purposes.
