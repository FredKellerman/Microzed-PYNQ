# Microzed-PYNQ

This repo contains build scripts and source code to enable PYNQ on the Avnet MicroZed boards.  The final SD card image should work on all Microzed board variants.  It has been tested on both the 7010 and 7020 versions.

PYNQ, Python productivity for Zynq is a framework developed by Xilinx Corporation.  See http://www.pynq.io

Microzed is Copyright Avnet Inc.

**To build the images the first time I recommend using a VM or non VM machine that is not used for critical work.  Installing the build tools will make various changes to your machine, make sure you know what you're getting into before you modify a critical work PC.  This process requires a passwordless sudo user for example.**

To rebuild your own Microzed PYNQ image you will need to complete the following pre-build steps.  If you are already setup to build v2.6 PYNQ, skip these:

* You will need at least 16GB of PC RAM and 30GB+ just for building the SD Image, not including space for the build tools
* Install Petalinux v2020.1, Vivado v2020.1 and Ubuntu 18.04 LTS on an x86 PC
* Give an Ubuntu 'build user' passwordless sudo permission
* Clone PYNQ from https://github.com/Xilinx/PYNQ **and checkout branch: image_v2.6.0**
* From the clone and proper branch **execute "./sdbuild/scripts/setup_host.sh"**
* Install any requested additonal Debian apt packages that setup_host.sh asks for
* Once setup_host.sh is successful, **reboot and re-login**
* You may remove the just cloned PYNQ git repo

Once the previous steps have been completed you may begin building PYNQ for the Microzed 7010 or 7020:

* From a cmd line bash shell terminal, make sure Vivado 2020.1 and Petalinux v2020.1 are in your path.  This is usually done with "source"
* **Clone this Microzed-PYNQ** repo and **cd** into it
* **Execute "./buildfast.sh"** NOTE: by default this builds for 7020, for 7010 set BOARD_TYPE=7010 in buildfast.sh 
* **Wait** for the SD card image generation to complete: microzed-x-x.x.x.img
* Use Etcher to copy the .img file onto a >= 16GB micro SD card
* Setup the Microzed dip switches to boot from SD card, insert SD card, **power-up and get to work!**

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
