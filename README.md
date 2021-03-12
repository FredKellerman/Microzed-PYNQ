# Microzed-PYNQ

This free and open source custom port of PYNQ is a product of 6d7 Technologies LLC. The final SD card image should work on all Microzed board variants.  It has been tested the 7010 and 7020 versions.

PYNQ is a registered trademark owned by Xilinx Corporation.

Microzed is Copyright Avnet Inc.

**Use a VM or machine that is not critical, installing the build tools will make various changes to your PC**

To rebuild your own Microzed PYNQ image:

* You will need at least 16GB of PC RAM and 30GB+ just for building the SD Image, not including space for the build tools
* Install Petalinux and Vivado v2020.1 tools on Ubuntu 18.04 LTS
* Setup a 'build user' with passwordless sudo
* Clone PYNQ from https://github.com/Xilinx/PYNQ **and checkout branch: image_v2.6.0**
* From the clone and proper branch **execute ./sdbuild/scripts/setup_host.sh**
* Install any requested additonal apt packages that setup_host.sh asks for
* Once setup_host.sh is successful, **reboot and re-login**
* You may remove the just cloned PYNQ git repo
* **Clone this Microzed-PYNQ** repo and cd into it
* **Run ./buildfast.sh** NOTE: by default this builds for 7020, for 7010 set BOARD_TYPE=7010 in buildfast.sh 
* **Wait** for the SD card image generation to complete: microzed-x-x.x.x.img
* Use Etcher to copy .img onto >= 16GB micro SD card
* Setup the Microzed dip switches to boot from SD card, insert card, **power-up and get to work!**

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
